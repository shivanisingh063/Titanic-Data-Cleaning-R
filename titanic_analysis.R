# ==========================================================
# DATA CLEANING AND PRELIMINARY ANALYSIS WITH R
# Dataset: Titanic Passenger Dataset
# ==========================================================


# ==========================================================
# 1. LOAD REQUIRED PACKAGES
# ==========================================================

library(tidyverse)


# ==========================================================
# 2. LOAD THE DATASET
# ==========================================================

titanic <- read.csv(
  "titanic.csv",
  stringsAsFactors = FALSE,
  na.strings = c("", "NA")
)


# ==========================================================
# 3. INITIAL DATA INSPECTION
# ==========================================================

# Dimensions of the dataset
dim(titanic)

# First six rows
head(titanic)

# Structure of the dataset
str(titanic)

# Summary statistics
summary(titanic)


# ==========================================================
# 4. MISSING VALUE ANALYSIS
# ==========================================================

# Count missing values in each column
missing_count <- colSums(is.na(titanic))

missing_count


# Calculate percentage of missing values
missing_percent <- round(
  missing_count / nrow(titanic) * 100,
  2
)

missing_percent


# Create a missing-value summary table
missing_table <- data.frame(
  Variable = names(missing_count),
  Missing_Count = as.integer(missing_count),
  Missing_Percentage = missing_percent
)

missing_table


# ==========================================================
# 5. MISSING VALUE TREATMENT
# ==========================================================

# Find the most common Embarked value
embarked_mode <- names(
  sort(
    table(titanic$Embarked),
    decreasing = TRUE
  )
)[1]

embarked_mode


# Calculate median Age
age_median <- median(
  titanic$Age,
  na.rm = TRUE
)

age_median


# Create a copy of the original dataset
titanic_clean <- titanic


# Impute missing Age values using median
titanic_clean$Age[
  is.na(titanic_clean$Age)
] <- age_median


# Impute missing Embarked values using mode
titanic_clean$Embarked[
  is.na(titanic_clean$Embarked)
] <- embarked_mode


# Remove Cabin because 77.10% of its values are missing
titanic_clean$Cabin <- NULL


# Check missing values after cleaning
colSums(is.na(titanic_clean))


# Check structure after cleaning
str(titanic_clean)


# ==========================================================
# 6. OUTLIER DETECTION USING IQR
# ==========================================================

detect_outliers <- function(x) {
  
  Q1 <- quantile(
    x,
    0.25,
    na.rm = TRUE
  )
  
  Q3 <- quantile(
    x,
    0.75,
    na.rm = TRUE
  )
  
  IQR_value <- Q3 - Q1
  
  lower_bound <- Q1 - 1.5 * IQR_value
  
  upper_bound <- Q3 + 1.5 * IQR_value
  
  outliers <- x[
    x < lower_bound |
      x > upper_bound
  ]
  
  list(
    Q1 = Q1,
    Q3 = Q3,
    IQR = IQR_value,
    Lower_Bound = lower_bound,
    Upper_Bound = upper_bound,
    Outlier_Count = length(outliers)
  )
}


# Detect Age outliers
age_outliers <- detect_outliers(
  titanic_clean$Age
)

age_outliers


# Detect Fare outliers
fare_outliers <- detect_outliers(
  titanic_clean$Fare
)

fare_outliers


# Detect SibSp outliers
sibsp_outliers <- detect_outliers(
  titanic_clean$SibSp
)

sibsp_outliers


# Detect Parch outliers
parch_outliers <- detect_outliers(
  titanic_clean$Parch
)

parch_outliers


# Create final outlier summary table
outlier_summary <- data.frame(
  
  Variable = c(
    "Age",
    "Fare",
    "SibSp",
    "Parch"
  ),
  
  Q1 = c(
    age_outliers$Q1,
    fare_outliers$Q1,
    sibsp_outliers$Q1,
    parch_outliers$Q1
  ),
  
  Q3 = c(
    age_outliers$Q3,
    fare_outliers$Q3,
    sibsp_outliers$Q3,
    parch_outliers$Q3
  ),
  
  IQR = c(
    age_outliers$IQR,
    fare_outliers$IQR,
    sibsp_outliers$IQR,
    parch_outliers$IQR
  ),
  
  Lower_Bound = c(
    age_outliers$Lower_Bound,
    fare_outliers$Lower_Bound,
    sibsp_outliers$Lower_Bound,
    parch_outliers$Lower_Bound
  ),
  
  Upper_Bound = c(
    age_outliers$Upper_Bound,
    fare_outliers$Upper_Bound,
    sibsp_outliers$Upper_Bound,
    parch_outliers$Upper_Bound
  ),
  
  Outlier_Count = c(
    age_outliers$Outlier_Count,
    fare_outliers$Outlier_Count,
    sibsp_outliers$Outlier_Count,
    parch_outliers$Outlier_Count
  )
)

outlier_summary


# ==========================================================
# 7. OUTLIER VISUALIZATION
# ==========================================================

# Boxplot for Age

boxplot(
  titanic_clean$Age,
  main = "Boxplot of Age",
  ylab = "Age"
)


# Boxplot for Fare

boxplot(
  titanic_clean$Fare,
  main = "Boxplot of Fare",
  ylab = "Fare"
)


# ==========================================================
# 8. CATEGORICAL VARIABLE ANALYSIS
# ==========================================================

# Check unique values

unique(titanic_clean$Sex)

unique(titanic_clean$Embarked)


# Convert categorical variables to factors

titanic_clean$Sex <- factor(
  titanic_clean$Sex
)

titanic_clean$Embarked <- factor(
  titanic_clean$Embarked
)


# Check structure after converting to factors

str(titanic_clean)


# ==========================================================
# 9. CATEGORICAL ENCODING
# ==========================================================

# Create dummy variables for Sex and Embarked

encoded_data <- model.matrix(
  ~ Sex + Embarked - 1,
  data = titanic_clean
)

encoded_data <- as.data.frame(
  encoded_data
)


# Display encoded variables

head(encoded_data)


# Combine encoded variables with numerical variables

titanic_encoded <- cbind(
  titanic_clean[
    c(
      "Survived",
      "Pclass",
      "Age",
      "SibSp",
      "Parch",
      "Fare"
    )
  ],
  encoded_data
)


# Inspect encoded dataset

head(titanic_encoded)

str(titanic_encoded)


# ==========================================================
# 10. NORMALIZATION
# ==========================================================

# Select numerical variables for normalization

numeric_columns <- c(
  "Age",
  "SibSp",
  "Parch",
  "Fare"
)


# Create normalized dataset

titanic_normalized <- titanic_encoded


# Apply Z-score normalization

titanic_normalized[
  numeric_columns
] <- scale(
  titanic_encoded[
    numeric_columns
  ]
)


# Display normalized data

head(titanic_normalized)


# Verify means

sapply(
  titanic_normalized[
    numeric_columns
  ],
  mean
)


# Verify standard deviations

sapply(
  titanic_normalized[
    numeric_columns
  ],
  sd
)


# ==========================================================
# 11. EXPLORATORY DATA ANALYSIS
# ==========================================================

# ----------------------------------------------------------
# 11.1 Overall Survival Rate
# ----------------------------------------------------------

overall_survival <- mean(
  titanic_clean$Survived
) * 100

overall_survival


# Survival counts

table(
  titanic_clean$Survived
)


# Summary of cleaned dataset

summary(
  titanic_clean
)


# ----------------------------------------------------------
# 11.2 Survival Rate by Sex
# ----------------------------------------------------------

survival_by_sex <- titanic_clean %>%
  group_by(Sex) %>%
  summarise(
    Passengers = n(),
    Survivors = sum(Survived),
    Survival_Rate = mean(Survived) * 100
  )

survival_by_sex


# Visualization

ggplot(
  survival_by_sex,
  aes(
    x = Sex,
    y = Survival_Rate
  )
) +
  geom_col() +
  labs(
    title = "Survival Rate by Sex",
    x = "Sex",
    y = "Survival Rate (%)"
  ) +
  theme_minimal()


# ----------------------------------------------------------
# 11.3 Survival Rate by Passenger Class
# ----------------------------------------------------------

class_passengers <- table(
  titanic_clean$Pclass
)


class_survivors <- tapply(
  titanic_clean$Survived,
  titanic_clean$Pclass,
  sum
)


class_survival_rate <- round(
  class_survivors /
    class_passengers * 100,
  2
)


survival_by_class <- data.frame(
  
  Pclass = names(
    class_passengers
  ),
  
  Passengers = as.vector(
    class_passengers
  ),
  
  Survivors = as.vector(
    class_survivors
  ),
  
  Survival_Rate = as.vector(
    class_survival_rate
  )
)


survival_by_class


# Visualization

ggplot(
  survival_by_class,
  aes(
    x = factor(Pclass),
    y = Survival_Rate
  )
) +
  geom_col() +
  labs(
    title = "Survival Rate by Passenger Class",
    x = "Passenger Class",
    y = "Survival Rate (%)"
  ) +
  theme_minimal()


# ----------------------------------------------------------
# 11.4 Age Descriptive Statistics
# ----------------------------------------------------------

age_mean <- mean(
  titanic_clean$Age
)

age_median_clean <- median(
  titanic_clean$Age
)

age_min <- min(
  titanic_clean$Age
)

age_max <- max(
  titanic_clean$Age
)

age_sd <- sd(
  titanic_clean$Age
)


age_descriptive_statistics <- data.frame(
  
  Statistic = c(
    "Mean",
    "Median",
    "Minimum",
    "Maximum",
    "Standard Deviation"
  ),
  
  Value = c(
    age_mean,
    age_median_clean,
    age_min,
    age_max,
    age_sd
  )
)


age_descriptive_statistics


# Age distribution

ggplot(
  titanic_clean,
  aes(x = Age)
) +
  geom_histogram(
    bins = 30
  ) +
  geom_vline(
    xintercept = age_median_clean,
    linetype = "dashed"
  ) +
  labs(
    title = "Distribution of Passenger Age",
    subtitle = "Dashed line represents the median age used for imputation",
    x = "Age",
    y = "Number of Passengers"
  ) +
  theme_minimal()


# ----------------------------------------------------------
# 11.5 Fare Descriptive Statistics
# ----------------------------------------------------------

fare_mean <- mean(
  titanic_clean$Fare
)

fare_median <- median(
  titanic_clean$Fare
)

fare_min <- min(
  titanic_clean$Fare
)

fare_max <- max(
  titanic_clean$Fare
)

fare_sd <- sd(
  titanic_clean$Fare
)


fare_descriptive_statistics <- data.frame(
  
  Statistic = c(
    "Mean",
    "Median",
    "Minimum",
    "Maximum",
    "Standard Deviation"
  ),
  
  Value = c(
    fare_mean,
    fare_median,
    fare_min,
    fare_max,
    fare_sd
  )
)


fare_descriptive_statistics


# Fare distribution

ggplot(
  titanic_clean,
  aes(x = Fare)
) +
  geom_histogram(
    bins = 30
  ) +
  geom_vline(
    xintercept = fare_median,
    linetype = "dashed"
  ) +
  labs(
    title = "Distribution of Passenger Fare",
    subtitle = "Dashed line represents the median fare",
    x = "Fare",
    y = "Number of Passengers"
  ) +
  theme_minimal()


# ==========================================================
# 12. CORRELATION ANALYSIS
# ==========================================================

# Select numerical variables

correlation_data <- titanic_clean[
  c(
    "Survived",
    "Pclass",
    "Age",
    "SibSp",
    "Parch",
    "Fare"
  )
]


# Calculate correlation matrix

correlation_matrix <- cor(
  correlation_data,
  use = "complete.obs"
)


# Display rounded correlation matrix

round(
  correlation_matrix,
  2
)


# ==========================================================
# 13. CORRELATION HEATMAP
# ==========================================================

correlation_long <- as.data.frame(
  as.table(
    correlation_matrix
  )
)


names(correlation_long) <- c(
  "Variable1",
  "Variable2",
  "Correlation"
)


ggplot(
  correlation_long,
  aes(
    x = Variable1,
    y = Variable2,
    fill = Correlation
  )
) +
  geom_tile() +
  geom_text(
    aes(
      label = round(
        Correlation,
        2
      )
    ),
    size = 3
  ) +
  labs(
    title = "Correlation Matrix of Numerical Variables",
    x = "",
    y = "",
    fill = "Correlation"
  ) +
  theme_minimal()


# ==========================================================
# 14. FINAL DESCRIPTIVE STATISTICS
# ==========================================================

descriptive_statistics <- data.frame(
  
  Variable = c(
    "Age",
    "Fare",
    "SibSp",
    "Parch"
  ),
  
  Mean = c(
    mean(titanic_clean$Age),
    mean(titanic_clean$Fare),
    mean(titanic_clean$SibSp),
    mean(titanic_clean$Parch)
  ),
  
  Median = c(
    median(titanic_clean$Age),
    median(titanic_clean$Fare),
    median(titanic_clean$SibSp),
    median(titanic_clean$Parch)
  ),
  
  Minimum = c(
    min(titanic_clean$Age),
    min(titanic_clean$Fare),
    min(titanic_clean$SibSp),
    min(titanic_clean$Parch)
  ),
  
  Maximum = c(
    max(titanic_clean$Age),
    max(titanic_clean$Fare),
    max(titanic_clean$SibSp),
    max(titanic_clean$Parch)
  ),
  
  SD = c(
    sd(titanic_clean$Age),
    sd(titanic_clean$Fare),
    sd(titanic_clean$SibSp),
    sd(titanic_clean$Parch)
  )
)


# Round numerical columns only

descriptive_statistics[
  , -1
] <- round(
  descriptive_statistics[
    , -1
  ],
  2
)


# Display final table

descriptive_statistics


# ==========================================================
# 15. SAVE CLEANED DATASET
# ==========================================================

write.csv(
  titanic_clean,
  "titanic_cleaned.csv",
  row.names = FALSE
)


# ==========================================================
# END OF ANALYSIS
# ==========================================================

print(
  "Data cleaning and preliminary analysis completed successfully."
)