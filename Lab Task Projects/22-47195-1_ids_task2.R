library(ggcorrplot)
library(FSelectorRcpp)
library(ggplot2)

data <- read.csv("D:/UNIVERSITY/10TH  SEMESTER, 2024-2025, SPRING/INTRODUCTION TO DATA SCIENCE/Lab Task Projects/sleep_health_lifestyle_dataset.csv", stringsAsFactors = FALSE)
print(colnames(data))
colnames(data) <- c(
  "PersonID",
  "Gender",
  "Age",
  "Occupation",
  "SleepDuration",
  "QualityOfSleep",
  "PhysicalActivity",
  "StressLevel",
  "BMICategory",
  "BloodPressure",
  "HeartRate",
  "DailySteps",
  "SleepDisorder"
)

bp_split <- strsplit(as.character(data$BloodPressure), split = "/")
data$Systolic <- as.numeric(sapply(bp_split, `[`, 1))
data$Diastolic <- as.numeric(sapply(bp_split, `[`, 2))
head(data[, c("BloodPressure", "Systolic", "Diastolic")])

data <- data[, c(
  "PersonID", "Gender", "Age", "Occupation", "SleepDuration", "QualityOfSleep",
  "PhysicalActivity", "StressLevel", "BMICategory", "BloodPressure", 
  "Systolic", "Diastolic", "HeartRate", "DailySteps",
  "SleepDisorder"
)]

numeric_cols <- c("Age", "SleepDuration", "QualityOfSleep", "PhysicalActivity", 
                  "StressLevel", "Systolic", "Diastolic", "HeartRate", "DailySteps")

categorical_cols <- c("Gender", "Occupation", "BMICategory")

data$SleepDisorder <- as.factor(data$SleepDisorder)
data$Gender <- as.factor(data$Gender)
data$Occupation <- as.factor(data$Occupation)
data$BMICategory <- as.factor(data$BMICategory)



cor_data <- data[, numeric_cols]
cor_matrix <- cor(cor_data, use = "complete.obs", method = "pearson")
print(round(cor_matrix, 2))
ggcorrplot(cor_matrix, 
           hc.order = TRUE, 
           type = "lower", 
           lab = TRUE, 
           lab_size = 3, 
           lab_col = "navy", 
           colors = c("orangered", "white", "mediumturquoise"),
           title = "Correlation Matrix",
           ggtheme = theme_minimal() +
             theme(
               plot.title = element_text(color = "darkred", size = 14, face = "bold"),
               axis.title = element_text(color = "navy", size = 14)
             ))



p_threshold <- 0.5
significant_features_ANOVA <- c()
for (col in numeric_cols) 
{
  formula <- as.formula(paste(col, "~ SleepDisorder"))
  aov_result <- aov(formula, data = data)
  summary_result <- summary(aov_result)
  p_value <- summary_result[[1]][["Pr(>F)"]][1]
  cat("----------------------------------------------------------------")
  cat("\nANOVA for:", col, "\n")
  print(summary_result)
  if (!is.na(p_value) && p_value < p_threshold) {
    significant_features_ANOVA <- c(significant_features_ANOVA, col)
  }
}
cat("\nFeatures Selected After ANOVA:\n", significant_features_ANOVA, sep = "\n") 



for (feature in significant_features_ANOVA) 
{
  ggplot(data, aes_string(x = "SleepDisorder", y = feature, fill = "SleepDisorder")) +
    geom_boxplot() +
    labs(title = paste("Boxplot of", feature, "by SleepDisorder")) +
    theme_minimal() -> p
  
  print(p)
  readline("Press Enter for next plot.")
}


p_threshold <- 0.5
significant_features_chi <- c()
for (col in categorical_cols) 
{
  tbl <- table(data[[col]], data$SleepDisorder)
  chi_result <- chisq.test(tbl)
  cat("----------------------------------------------")
  cat("\nChi-squared test for:", col, "\n")
  print(chi_result)
  if (!is.na(chi_result$p.value) && chi_result$p.value < p_threshold) 
  {
    significant_features_chi <- c(significant_features_chi, col)
  }
}
cat("\nFeatures Selected After Chi-Squared Test:\n", significant_features_chi)



formula_cat <- as.formula(paste("SleepDisorder ~", paste(categorical_cols, collapse = "+")))
mi_scores_cat <- information_gain(formula_cat, data)
mi_scores_cat_sorted <- mi_scores_cat[order(-mi_scores_cat$importance), ]
print(mi_scores_cat_sorted)
ggplot(mi_scores_cat_sorted, aes(x = reorder(attributes, importance), y = importance, fill = importance)) +
  geom_bar(stat = "identity") +
  coord_flip() +
  labs(title = "Mutual Information Scores of Categorical Features",
       x = "Features",
       y = "Mutual Information") +
  theme_minimal() +
  theme(
    plot.title = element_text(color = "darkred", size = 14, face = "bold"),
    axis.title = element_text(color = "navy", size = 14)
  )+
  scale_fill_gradient(low = "hotpink", high = "darkblue")
