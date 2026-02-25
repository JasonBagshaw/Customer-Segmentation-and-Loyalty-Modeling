Customer Segmentation and Loyalty Modelling
Overview

This project applies unsupervised and supervised machine learning techniques to analyse customer behaviour and model loyalty programme performance.

The objectives were:

Identify meaningful customer segments

Understand the drivers of loyalty points earned

Build predictive models for loyalty behaviour

Translate behavioural data into actionable insights

This project demonstrates a full end-to-end data science workflow, from exploratory analysis and feature engineering through to modelling and interpretation.

Dataset

The dataset contains customer-level information including:

Salary

Spending Score

Age

Gender

Education

Loyalty Points

The target variable is:

Loyalty Points

Techniques Used
Unsupervised Learning

K-Means Clustering

DBSCAN

Hierarchical Clustering

Customer Segmentation

Supervised Learning

Decision Tree Classification

Multiple Linear Regression

Polynomial Regression

Interaction Models

Log Transformation

Statistical Analysis

Residual diagnostics

Normality testing

Skewness and kurtosis analysis

Variance stabilisation

Project Structure
customer-segmentation-loyalty-model/
│
├── customer_segmentation.R
├── turtle_reviews.csv
├── README.md
Exploratory Analysis

Initial analysis identified strong relationships between:

Salary and Loyalty Points

Spending Score and Loyalty Points

Exploration showed that segmentation improved model interpretability, suggesting customer groups behave differently.

Customer Segmentation

Several clustering approaches were evaluated:

K-Means clustering

DBSCAN clustering

Hierarchical clustering

Hierarchical clustering produced the most interpretable customer groups.

Segmentation was primarily driven by:

Salary

Spending Score

Custom Segmentation Model

Customers were divided into interpretable segments based on salary and spending score ranges.

Each segment was analysed to determine average loyalty performance.

This segmentation approach produced clear behavioural differences between customer groups.

Segment Value Heatmap

This visualisation combines:

Customer density (scatter plot)

Segment boundaries

Average loyalty value per segment

This allows easy identification of high-value customer segments.

Example Output
