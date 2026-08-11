# Titanic Data Cleaning and Preliminary Analysis with R

## 📌 Project Overview

This project focuses on cleaning, preprocessing, and performing preliminary exploratory analysis on the Titanic Passenger Dataset using R.

The main goal of the project was to understand how raw data can be prepared for further analysis by handling missing values, identifying outliers, encoding categorical variables, normalizing numerical variables, and exploring important patterns in the dataset.

## 📊 Dataset

The Titanic dataset contains information about 891 passengers and includes both numerical and categorical variables.

### Dataset Source

Data Science Dojo – Titanic Dataset:

https://github.com/datasciencedojo/datasets/blob/master/titanic.csv

### Main Variables

- `Survived` – Survival status
- `Pclass` – Passenger class
- `Sex` – Passenger sex
- `Age` – Passenger age
- `SibSp` – Number of siblings/spouses aboard
- `Parch` – Number of parents/children aboard
- `Fare` – Passenger fare
- `Embarked` – Port of embarkation
- `Cabin` – Cabin information

## 🛠️ Tools and Technologies

- R
- RStudio / Visual Studio Code
- tidyverse
- ggplot2
- Git
- GitHub

## 🧹 Data Cleaning

The following data-cleaning techniques were applied:

### Missing Values

- Missing `Age` values were replaced using the median age.
- Missing `Embarked` values were replaced using the mode.
- `Cabin` was removed because 77.10% of its values were missing.

### Outlier Detection

Potential outliers were identified using the Interquartile Range (IQR) method.

Outliers were detected in:

- Age
- Fare
- SibSp
- Parch

The detected observations were retained because extreme values can represent legitimate passenger characteristics.

### Categorical Encoding

Categorical variables such as `Sex` and `Embarked` were converted into factors and encoded using dummy variables with `model.matrix()`.

### Normalization

Z-score normalization was applied to:

- Age
- SibSp
- Parch
- Fare

The normalized variables were checked to confirm approximately zero mean and unit standard deviation.

## 📈 Exploratory Data Analysis

Several analyses and visualizations were created, including:

- Survival rate by sex
- Survival rate by passenger class
- Passenger age distribution
- Passenger fare distribution
- Correlation matrix
- Age and Fare boxplots
- Descriptive statistics

## 🔎 Key Findings

- The overall survival rate was approximately **38.38%**.
- Female passengers had a much higher observed survival rate than male passengers.
- First-class passengers had the highest survival rate at approximately **62.96%**.
- Second-class passengers had a survival rate of approximately **47.28%**.
- Third-class passengers had the lowest survival rate at approximately **24.24%**.
- Passenger age had a mean of **29.36 years** and a median of **28 years**.
- Fare was strongly right-skewed, with a mean of **32.20** and a median of **14.45**.
- `Pclass` had a moderate negative correlation with `Survived` (-0.34).
- `Fare` had a weak-to-moderate positive correlation with `Survived` (0.26).

## 📁 Project Structure

```text
Titanic-Data-Cleaning-R/
│
├── titanic_analysis.R
├── titanic.csv
├── titanic_cleaned.csv
├── README.md
│
└── screenshot/
    ├── age_boxplot.png
    ├── age_descriptive_statistics.png
    ├── age_distribution.png
    ├── age_distribution_with_median.png
    ├── categorical_encoding.png
    ├── correlation_matrix.png
    ├── descriptive_statistics.png
    ├── fare_boxplot.png
    ├── fare_descriptive_statistics.png
    ├── fare_distribution.png
    ├── missing_value_analysis.png
    ├── missing_values_after_cleaning.png
    ├── normalization_verification.png
    ├── normalized_data.png
    ├── outlier_summary.png
    ├── survival_by_class.png
    └── survival_by_sex.png