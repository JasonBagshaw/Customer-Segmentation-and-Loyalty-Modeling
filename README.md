Customer Segmentation and Loyalty Modelling (R)
Overview

This project applies both unsupervised and supervised learning techniques to analyse customer behaviour and loyalty programme performance.

The analysis identifies meaningful customer segments and builds predictive models to understand the drivers of loyalty points earned.

The objective is to translate behavioural data into actionable insights that could support marketing strategy and customer retention initiatives.

Business Context

Customer behaviour is rarely homogeneous. Identifying high-value segments and understanding the drivers of loyalty can help organisations:

Optimise targeting strategies

Personalise promotions

Improve customer retention

Allocate marketing resources more effectively

This project demonstrates how clustering and regression modelling can be combined to generate both segmentation insight and predictive capability.

Methods & Techniques
Unsupervised Learning (Segmentation)

K-Means Clustering

Hierarchical Clustering (Ward’s method)

Cluster visualisation and interpretation

Decision Tree modelling to extract interpretable cluster assignment rules

Supervised Learning (Prediction)

Multiple Linear Regression

Interaction Effects (Salary × Spending Score)

Polynomial Terms

Log transformation to address heteroscedasticity

Residual diagnostics and model evaluation

Statistical Diagnostics

Distribution analysis

Shapiro-Wilk normality testing

Skewness and kurtosis evaluation

Residual analysis

Key Findings

Distinct behavioural clusters emerge based on salary and spending score.

Cluster boundaries can be interpreted using decision tree rules.

Interaction effects between salary and spending score significantly improve predictive performance.

Log transformation stabilises variance and improves model diagnostics.

Segment-level analysis reveals clear differences in average loyalty performance across groups.

Visual Outputs

The project includes:

Cluster visualisations

Decision tree diagram for rule extraction

Predicted vs. actual comparison plots

Segment-level loyalty comparison charts

Distribution diagnostics

Tools & Libraries

R

tidyverse

ggplot2

cluster

rpart

psych

Project Structure
customer-segmentation-and-loyalty-modelling-r/
│
├── customer_segmentation_loyalty_modelling.R
├── turtle_reviews.csv  (if included)
└── README.md
Skills Demonstrated

End-to-end analytical workflow

Customer segmentation strategy

Feature engineering and transformation

Model comparison and refinement

Diagnostic evaluation of regression assumptions

Translation of statistical modelling into business insight

Positioning

This project demonstrates applied modelling capability beyond basic coursework, combining:

Unsupervised learning

Supervised learning

Statistical reasoning

Business interpretation

It reflects a practical data science approach suitable for junior data scientist and AI data roles.# Customer-Segmentation-and-Loyalty-Modeling
