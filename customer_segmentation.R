# =====================================================
# Customer Segmentation and Loyalty Modelling in R
# =====================================================
#
# Objective:
# Identify meaningful customer segments using clustering techniques
# and model the drivers of loyalty programme performance using regression.
#
# Techniques:
# - K-Means Clustering
# - Hierarchical Clustering
# - Decision Trees (Rule Extraction)
# - Multiple Linear Regression
# - Polynomial & Interaction Terms
# - Log Transformation & Residual Diagnostics
# =====================================================


# =====================================================
# 1. Libraries
# =====================================================

library(tidyverse)
library(ggplot2)
library(dplyr)
library(cluster)
library(rpart)
library(rpart.plot)
library(psych)


# =====================================================
# 2. Data Preparation
# =====================================================

tr <- read.csv("turtle_reviews.csv", header = TRUE)

tr1 <- tr %>%
  select(-c(language, platform)) %>%
  rename(
    sscore = spending_score..1.100.,
    salary = remuneration..k..
  )

summary(tr1)


# =====================================================
# 3. Exploratory Analysis
# =====================================================

ggplot(tr1, aes(x = salary, y = loyalty_points)) +
  geom_point(alpha = 0.6) +
  geom_smooth(method = "lm") +
  labs(title = "Salary vs Loyalty Points")


ggplot(tr1, aes(x = sscore, y = loyalty_points)) +
  geom_point(alpha = 0.6) +
  geom_smooth(method = "lm") +
  labs(title = "Spending Score vs Loyalty Points")


# =====================================================
# 4. Clustering Analysis
# =====================================================

# --- K-Means Clustering ---

trk <- tr1 %>% select(sscore, salary, loyalty_points)

set.seed(42)
kmeans_result <- kmeans(trk, centers = 5, nstart = 50)

trk$cluster <- as.factor(kmeans_result$cluster)

ggplot(trk, aes(x = salary, y = sscore, color = cluster)) +
  geom_point() +
  labs(title = "K-Means Customer Segmentation")


# --- Hierarchical Clustering ---

scaled_data <- scale(trk[, 1:3])
dist_matrix <- dist(scaled_data)
hclust_result <- hclust(dist_matrix, method = "ward.D2")

clusters <- cutree(hclust_result, k = 5)
trk$h_cluster <- as.factor(clusters)

ggplot(trk, aes(x = salary, y = sscore, color = h_cluster)) +
  geom_point() +
  labs(title = "Hierarchical Clustering Segmentation")


# =====================================================
# 5. Decision Tree (Cluster Rule Extraction)
# =====================================================

tree_model <- rpart(h_cluster ~ sscore + salary + loyalty_points,
                    data = trk,
                    method = "class")

rpart.plot(tree_model,
           type = 4,
           extra = 1,
           main = "Decision Tree for Cluster Assignment")


# =====================================================
# 6. Regression Modelling
# =====================================================

# Baseline Linear Model
baseline_model <- lm(loyalty_points ~ salary + sscore, data = tr1)
summary(baseline_model)


# Interaction Model
interaction_model <- lm(loyalty_points ~ salary * sscore, data = tr1)
summary(interaction_model)


# Log-Transformed Polynomial Model (Variance Stabilisation)
log_model <- lm(log(loyalty_points) ~ salary + sscore +
                  I(salary^2) + I(sscore^2),
                data = tr1)

summary(log_model)

plot(log_model, which = 1)


# Generate Predictions (Back-transformed)

tr1$predicted_log <- predict(log_model, tr1)
tr1$predicted_loyalty <- exp(tr1$predicted_log)

ggplot(tr1, aes(x = predicted_loyalty, y = loyalty_points)) +
  geom_point(alpha = 0.5) +
  geom_abline(intercept = 0, slope = 1,
              linetype = "dashed", color = "red") +
  labs(title = "Predicted vs Actual Loyalty Points")


# =====================================================
# 7. Manual Segment Construction (Business-Focused Grid)
# =====================================================

tr2 <- tr1 %>%
  mutate(
    Segment = case_when(
      # High SScore (Top Row)
      sscore > 60 & salary > 57 ~ "HighS_HighSal",
      sscore > 60 & salary >= 32 & salary <= 57 ~ "HighS_MidSal",
      sscore > 60 & salary < 32 ~ "HighS_LowSal",
      
      # Mid SScore (Middle Row)
      sscore >= 40 & sscore <= 60 & salary > 57 ~ "MidS_HighSal",
      sscore >= 40 & sscore <= 60 & salary >= 32 & salary <= 57 ~ "MidS_MidSal",
      sscore >= 40 & sscore <= 60 & salary < 32 ~ "MidS_LowSal",
      
      # Low SScore (Bottom Row)
      sscore < 40 & salary > 57 ~ "LowS_HighSal",
      sscore < 40 & salary >= 32 & salary <= 57 ~ "LowS_MidSal",
      TRUE ~ "LowS_LowSal"
    )
  )
segment_summary <- tr2 %>%
  group_by(Segment) %>%
  summarise(
    Avg_Loyalty = mean(loyalty_points, na.rm = TRUE),
    N = n()
  ) %>%
  filter(N >= 20) %>%
  arrange(desc(Avg_Loyalty))


ggplot(segment_summary,
       aes(x = reorder(Segment, Avg_Loyalty),
           y = Avg_Loyalty,
           fill = Avg_Loyalty)) +
  geom_col() +
  coord_flip() +
  theme_minimal() +
  labs(title = "Average Loyalty Points by Segment",
       x = "Segment",
       y = "Average Loyalty Points")


# ======================================
#     Heat Map visualization
# ======================================
library(ggplot2)
library(dplyr)

# 1. Create the summary data
segment_summary <- tr2 %>% 
  group_by(Segment) %>%
  summarise(
    Avg_Loyalty = mean(loyalty_points, na.rm = TRUE),
    N = n()
  ) %>%
  filter(N >= 20) %>%
  ungroup()

# 2. CREATE THE HEATMAP COORDINATES
segment_heatmap_data <- segment_summary %>%
  mutate(
    # Salary Boundaries (X-Axis) 
    salary_min = case_when(
      grepl("_LowSal", Segment)  ~ 0,
      grepl("_MidSal", Segment)  ~ 32,
      grepl("_HighSal", Segment) ~ 57
    ),
    salary_max = case_when(
      grepl("_LowSal", Segment)  ~ 32,
      grepl("_MidSal", Segment)  ~ 57,
      grepl("_HighSal", Segment) ~ 100
    ),
    salary_center = (salary_min + salary_max) / 2,
    
    # SScore Boundaries (Y-Axis) - Use the underscore to avoid matching "HighSal"
    sscore_min = case_when(
      grepl("LowS_", Segment)  ~ 0,
      grepl("MidS_", Segment)  ~ 40,
      grepl("HighS_", Segment) ~ 60
    ),
    sscore_max = case_when(
      grepl("LowS_", Segment)  ~ 40,
      grepl("MidS_", Segment)  ~ 60,
      grepl("HighS_", Segment) ~ 100
    ),
    sscore_center = (sscore_min + sscore_max) / 2
  )


# 3. Filter raw data for the scatter overlay
df_filtered <- tr2 %>% 
  filter(Segment %in% segment_summary$Segment)

# 4. Generate the Visualization
p_combined <- ggplot() +
  # Layer 1: The Heatmap Boxes
  geom_rect(
    data = segment_heatmap_data,
    aes(xmin = salary_min, xmax = salary_max, ymin = sscore_min, ymax = sscore_max, fill = Avg_Loyalty),
    alpha = 0.6, 
    color = "black", 
    linewidth = 0.5
  ) +
  # Layer 2: The Scatter Points
  geom_point(data = df_filtered, aes(x = salary, y = sscore), 
             color = "grey30", size = 1.5, alpha = 0.4) +
  # Layer 3: The Text Labels
  geom_text(
    data = segment_heatmap_data, 
    aes(x = salary_center, y = sscore_center, 
        label = paste0("Avg: ", round(Avg_Loyalty, 0), "\n(N=", N, ")")),
    color = "black", 
    size = 5,
    fontface = "bold"
  ) +
  scale_fill_gradient(low = "#FFD700", high = "#1B7E39", name = "Avg. Loyalty") +
  geom_vline(xintercept = c(32, 57), colour = 'red', linetype = "dashed", alpha = 0.5) +
  geom_hline(yintercept = c(40, 60), colour = 'red', linetype = "dashed", alpha = 0.5) +
  labs(
    title = "Customer Segment Value Overlay",
    subtitle = "Heatmap showing Average Loyalty vs. Density",
    x = "Salary",
    y = "SScore"
  ) +
  theme_minimal()

print(p_combined)




# =====================================================
# 8. Distribution & Diagnostics
# =====================================================

ggplot(tr1, aes(x = loyalty_points)) +
  geom_histogram(aes(y = after_stat(density)),
                 bins = 30,
                 fill = "skyblue",
                 color = "black") +
  geom_density(color = "red") +
  labs(title = "Distribution of Loyalty Points")


describe(tr1$loyalty_points)

shapiro.test(tr1$loyalty_points)

