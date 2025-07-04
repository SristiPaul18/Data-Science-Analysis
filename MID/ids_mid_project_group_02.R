#install.packages("dplyr")
library(dplyr)

#REMOVE COMMENTS
mydata <- read.csv("YOUR FILE PATH OF THE DATASET", header = TRUE, sep = ",")
copy_data <- mydata
View(copy_data)

cat("====== Dataset Summary ======\n")
summary(copy_data)

cat("\n====== Dataset Structure ======\n")
str(copy_data)

cat("\n====== Missing Values Check (NA): ======\n")
is.na(copy_data) 

cat("\n====== Total Number of Missing Values: ======\n")
sum(is.na(copy_data))

cat("\n====== Missing Values Per Column: ======\n")
colSums(is.na(copy_data))

cat("\n====== Empty Strings Per Column: ======\n")
colSums(copy_data == "")

cat("\n====== Missing Values After Replacing Empty Strings with NA: ======\n")
copy_data[copy_data == ""] <- NA
colSums(is.na(copy_data))


missing_age_rows <- which(is.na(copy_data$age))
cat("Rows with missing values in 'age' column: ", missing_age_rows, "\n")

mean_age <- as.integer(mean(copy_data$age, na.rm = TRUE))
cat("Mean age (calculated): ", mean_age, "\n")

copy_data$age[is.na(copy_data$age)] <- mean_age
cat("Missing values in 'age' column after replacement: ", 
    sum(is.na(copy_data$age)), "\n")


missing_ca_rows <- which(is.na(copy_data$ca))
cat("Rows with missing values in 'ca' column: ", missing_ca_rows, "\n")

cat("Frequency of 'ca' column:\n")
table(copy_data$ca)

mode_ca <- as.integer(names(sort(table(copy_data$ca), decreasing = TRUE))[1])
cat("Mode value of 'ca':", mode_ca, "\n")

copy_data$ca[is.na(copy_data$ca)] <- mode_ca
cat("Missing values in 'ca' column after replacement: ", 
    sum(is.na(copy_data$ca)), "\n")


missing_thal_rows <- which(is.na(copy_data$thal))
cat("Rows with missing values in 'thal' column: ", missing_thal_rows, "\n")

cat("Frequency of 'thal' column:\n")
table(copy_data$thal)

mode_thal <- as.character(names(sort(table(copy_data$thal), decreasing = TRUE))[1])
cat("Mode value of 'thal': ", mode_thal, "\n")

copy_data$thal[is.na(copy_data$thal)] <- mode_thal
cat("Missing values in 'thal' after replacement: ", sum(is.na(copy_data$thal)), "\n")


cat("Identifying Outliers in Age Column:\n")
Q1_age <- quantile(copy_data$age, 0.25)
Q3_age <- quantile(copy_data$age, 0.75)
IQR_age <- Q3_age - Q1_age
lower_bound_age <- Q1_age - 1.5 * IQR_age
upper_bound_age <- Q3_age + 1.5 * IQR_age
age_outliers <- copy_data$age[copy_data$age < lower_bound_age | copy_data$age > upper_bound_age]
if(length(age_outliers) == 0) {
  cat("No outliers found in Age column.\n")
} else {
  cat("Outliers found in Age column:\n")
  age_outliers
}


cat("Identifying Outliers in trestbps Column:\n")
Q1_trestbps <- quantile(copy_data$trestbps, 0.25)
Q3_trestbps <- quantile(copy_data$trestbps, 0.75)
IQR_trestbps <- Q3_trestbps - Q1_trestbps
lower_bound_trestbps <- Q1_trestbps - 1.5 * IQR_trestbps
upper_bound_trestbps <- Q3_trestbps + 1.5 * IQR_trestbps
trestbps_indices <- which(copy_data$trestbps < lower_bound_trestbps | copy_data$trestbps > upper_bound_trestbps)
cat("Outliers found in Rows:\n")
trestbps_indices
trestbps_outliers <- copy_data$trestbps[copy_data$trestbps < lower_bound_trestbps | copy_data$trestbps > upper_bound_trestbps]
if(length(trestbps_outliers) == 0) {
  cat("No outliers found in trestbps column.\n")
} else {
  cat("Outliers found in trestbps column:\n")
  trestbps_outliers
}

median_trestbps <- median(copy_data$trestbps)
cat("Median Calculated:", median_trestbps, "\n")
copy_data$trestbps[copy_data$trestbps < lower_bound_trestbps | copy_data$trestbps > upper_bound_trestbps] <- median_trestbps
trestbps_outliers <- copy_data$trestbps[copy_data$trestbps < lower_bound_trestbps | copy_data$trestbps > upper_bound_trestbps]
if(length(trestbps_outliers) == 0) {
  cat("No outliers remain in trestbps column after replacement.\n")
} else {
  cat("Remaining outliers in trestbps column after replacement:\n")
  trestbps_outliers
}


cat("Identifying Outliers in chol Column:\n")
Q1_chol <- quantile(copy_data$chol, 0.25)
Q3_chol <- quantile(copy_data$chol, 0.75)
IQR_chol <- Q3_chol - Q1_chol
lower_bound_chol <- Q1_chol - 1.5 * IQR_chol
upper_bound_chol <- Q3_chol + 1.5 * IQR_chol
chol_indices <- which(copy_data$chol < lower_bound_chol | copy_data$chol > upper_bound_chol)
cat("Outliers found in Rows:\n")
chol_indices
chol_outliers <- copy_data$chol[copy_data$chol < lower_bound_chol | copy_data$chol > upper_bound_chol]
if(length(chol_outliers) == 0) {
  cat("No outliers found in chol column.\n")
} else {
  cat("Outliers found in chol column:\n")
  chol_outliers
}

cat("Replacing the invalid value 3600\n")
copy_data$chol[copy_data$chol == 3600] <- 360

median_chol <- median(copy_data$chol)
cat("Median Calculated:", median_chol, "\n")
copy_data$chol[copy_data$chol < lower_bound_chol | copy_data$chol > upper_bound_chol] <- median_chol
chol_outliers <- copy_data$chol[copy_data$chol < lower_bound_chol | copy_data$chol > upper_bound_chol]
if(length(chol_outliers) == 0) {
  cat("No outliers remain in chol column after replacement.\n")
} else {
  cat("Remaining outliers in chol column after replacement:\n")
  chol_outliers
}

cat("Identifying Outliers in thalach Column:\n")
Q1_thalach <- quantile(copy_data$thalach, 0.25)
Q3_thalach <- quantile(copy_data$thalach, 0.75)
IQR_thalach <- Q3_thalach - Q1_thalach
lower_bound_thalach <- Q1_thalach - 1.5 * IQR_thalach
upper_bound_thalach <- Q3_thalach + 1.5 * IQR_thalach
thalach_outliers <- copy_data$thalach[copy_data$thalach < lower_bound_thalach | copy_data$thalach > upper_bound_thalach]
if(length(thalach_outliers) == 0) {
  cat("No outliers found in thalach column.\n")
} else {
  cat("Outliers found in thalach column:\n")
  thalach_outliers
}


cat("Identifying Outliers in oldpeak Column:\n")
Q1_oldpeak <- quantile(copy_data$oldpeak, 0.25)
Q3_oldpeak <- quantile(copy_data$oldpeak, 0.75)
IQR_oldpeak <- Q3_oldpeak - Q1_oldpeak
lower_bound_oldpeak <- Q1_oldpeak - 1.5 * IQR_oldpeak
upper_bound_oldpeak <- Q3_oldpeak + 1.5 * IQR_oldpeak
oldpeak_indices <- which(copy_data$oldpeak < lower_bound_oldpeak | copy_data$oldpeak > upper_bound_oldpeak)
cat("Outliers found in Rows:\n")
oldpeak_indices
oldpeak_outliers <- copy_data$oldpeak[copy_data$oldpeak < lower_bound_oldpeak | copy_data$oldpeak > upper_bound_oldpeak]
if(length(oldpeak_outliers) == 0) {
  cat("No outliers found in oldpeak column.\n")
} else {
  cat("Outliers found in oldpeak column:\n")
  oldpeak_outliers
}

median_oldpeak <- median(copy_data$oldpeak)
cat("Median Calculated:", median_oldpeak, "\n")
copy_data$oldpeak[copy_data$oldpeak < lower_bound_oldpeak | copy_data$oldpeak > upper_bound_oldpeak] <- median_oldpeak
oldpeak_outliers <- copy_data$oldpeak[copy_data$oldpeak < lower_bound_oldpeak | copy_data$oldpeak > upper_bound_oldpeak]
if(length(oldpeak_outliers) == 0) {
  cat("No outliers remain in oldpeak column after replacement.\n")
} else {
  cat("Remaining outliers in oldpeak column after replacement:\n")
  oldpeak_outliers
}

cat("Converting 'thal' from categorical to numeric...\n")
copy_data$thal <- factor(copy_data$thal,
                    levels = c("normal", "fixed defect", "reversable defect"),
                    labels = c(1, 2, 3))
copy_data$thal <- as.numeric(as.character(copy_data$thal))


cat("Converting 'num' from numeric to categorical...\n")
copy_data$num <- factor(copy_data$num, 
                   levels = c(0, 1), 
                   labels = c("No", "Yes"))


names(copy_data)[16] <- "diagnosis"


normalize <- function(x) {
  (x - min(x)) / (max(x) - min(x))
}
copy_data$trestbps <- normalize(copy_data$trestbps)
copy_data$chol <- normalize(copy_data$chol)
copy_data$oldpeak <- normalize(copy_data$oldpeak)
copy_data$thalch <- normalize(copy_data$thalch)
cat("Normalized continuous attributes: trestbps, chol, oldpeak, thalch\n")


cat("Count of Dupliate rows:", sum(duplicated(copy_data)), "\n")


filtered_data <- subset(copy_data, age > 60 & chol > 0.7 & diagnosis == "Yes")
cat("Rows with high normalized cholesterol, and diagnosed with heart disease: ", 
                                                    nrow(filtered_data), "\n")


table(copy_data$sex)
cat("Invalid value in Row: ", which(copy_data$sex == "F"))
copy_data$sex[copy_data$sex == "F"] <- "Female"


new_rows <- 90
new_data <- data.frame(
  id = 217:306,
  age = sample(30:80, new_rows, replace = TRUE),
  sex = rep("Female", new_rows),
  dataset = rep("New", new_rows),
  cp = sample(unique(copy_data$cp), new_rows, replace = TRUE),
  trestbps = runif(new_rows, min(as.numeric(copy_data$trestbps)), max(as.numeric(copy_data$trestbps))),
  chol = runif(new_rows, min(as.numeric(copy_data$chol)), max(as.numeric(copy_data$chol))),
  fbs = sample(c(TRUE, FALSE), new_rows, replace = TRUE),
  restecg = sample(unique(copy_data$restecg), new_rows, replace = TRUE),
  thalch = runif(new_rows, min(as.numeric(copy_data$thalch)), max(as.numeric(copy_data$thalch))),
  exang = sample(c(TRUE, FALSE), new_rows, replace = TRUE),
  oldpeak = runif(new_rows, min(as.numeric(copy_data$oldpeak)), max(as.numeric(copy_data$oldpeak))),
  slope = sample(unique(copy_data$slope), new_rows, replace = TRUE),
  ca = sample(0:3, new_rows, replace = TRUE),
  thal = sample(1:3, new_rows, replace = TRUE),
  diagnosis = sample(c("No", "Yes"), new_rows, replace = TRUE)
)
copy_data <- rbind(copy_data, new_data)
cat("Final Female count:", sum(copy_data$sex == "Female"), "| Final Male count:", sum(copy_data$sex == "Male"), "\n")
str(copy_data)

mean_age <- mean(copy_data$age)
median_age <- median(copy_data$age)
age_table <- table(copy_data$age)
mode_age <- as.numeric(names(age_table)[which.max(age_table)])
cat("\n===== Patient Age =====\n")
cat("Mean Age:", round(mean_age, 1), "years\n")
cat("Median Age:", median_age, "years\n")
cat("Mode Age:", mode_age, "years\n")
cat("=======================\n\n")


diag_table <- table(copy_data$diagnosis)
mode_diag <- names(diag_table)[which.max(diag_table)]
cat("\n===== Diagnosis Distribution =====\n")
cat("Most Common Diagnosis:", mode_diag, "\n")
cat("Healthy vs Disease:\n")
print(diag_table)
cat("==============================\n\n")


mean_chol <- mean(copy_data$chol)
median_chol <- median(copy_data$chol)
chol_table <- table(round(copy_data$chol, 2))
mode_chol <- as.numeric(names(chol_table)[which.max(chol_table)])
cat("\n===== Cholesterol =====\n")
cat("Mean Cholesterol:", round(mean_chol, 3), "\n")
cat("Median Cholesterol:", round(median_chol, 3), "\n")
cat("Mode Cholesterol:", round(mode_chol, 3), "\n")
cat("(0 = min, 1 = max cholesterol)\n")
cat("================================\n\n")


cp_table <- table(copy_data$cp)
mode_cp <- names(cp_table)[which.max(cp_table)]
cat("\n===== Chest Pain Types =====\n")
cat("Most Common Chest Pain Type:", mode_cp, "\n")
cat("Full Distribution:\n")
print(cp_table)
cat("===========================\n")


age_range <- range(copy_data$age)
age_iqr <- IQR(copy_data$age)
age_var <- var(copy_data$age)
age_sd <- sd(copy_data$age)
cat("Age Spread Metrics:\n",
    "Range:", age_range[1], "-", age_range[2], "years\n",
    "IQR:", age_iqr, "years (middle 50% range)\n",
    "Variance:", round(age_var,1), "\n",
    "Standard Deviation:", round(age_sd,1), "years")


bp_range <- range(copy_data$trestbps)
bp_iqr <- IQR(copy_data$trestbps)
bp_var <- var(copy_data$trestbps)
bp_sd <- sd(copy_data$trestbps)
cat("\n\nNormalized Blood Pressure Spread:\n",
    "Range:", bp_range[1], "-", bp_range[2], "(0-1 scale)\n",
    "IQR:", round(bp_iqr,4), "(middle 50% range)\n",
    "Variance:", round(bp_var,5), "\n",
    "Standard Deviation:", round(bp_sd,3))


set.seed(123)
total_patients <- nrow(copy_data)
training_count <- round(0.7 * total_patients)
training_patients <- sample(total_patients, training_count)
training_set <- copy_data[training_patients, ]
test_set <- copy_data[-training_patients, ]
print(paste("Training patients:", nrow(training_set)))
print(paste("Test patients:", nrow(test_set)))
View(training_set)
View(test_set)


mean_age <- mean(training_set$age)
median_age <- median(training_set$age)
age_table <- table(training_set$age)
mode_age <- as.numeric(names(age_table)[which.max(age_table)])
cat("Patient Age:\n",
    "Mean:", round(mean_age,1), "years\n",
    "Median:", median_age, "years\n",
    "Mode:", mode_age, "years\n")


diag_table <- table(training_set$diagnosis)
mode_diag <- names(diag_table)[which.max(diag_table)]
cat("\nDiagnosis Distribution:\n",
    "Most common:", mode_diag, "\n",
    "Healthy vs Disease:\n")
print(diag_table)


mean_chol <- mean(training_set$chol)
median_chol <- median(training_set$chol)
chol_table <- table(round(training_set$chol,2))
mode_chol <- as.numeric(names(chol_table)[which.max(chol_table)])
cat("\nNormalized Cholesterol:\n",
    "Mean:", round(mean_chol,3), "\n",
    "Median:", round(median_chol,3), "\n",
    "Mode:", round(mode_chol,3), "\n",
    "(0 = min, 1 = max cholesterol)")


cp_table <- table(training_set$cp)
mode_cp <- names(cp_table)[which.max(cp_table)]
cat("\nChest Pain Types:\n",
    "Most common:", mode_cp, "\n",
    "Full distribution:\n")
print(cp_table)


age_range <- range(training_set$age)
age_iqr <- IQR(training_set$age)
age_var <- var(training_set$age)
age_sd <- sd(training_set$age)
cat("Age Spread Metrics:\n",
    "Range:", age_range[1], "-", age_range[2], "years\n",
    "IQR:", age_iqr, "years (middle 50% range)\n",
    "Variance:", round(age_var,1), "\n",
    "Standard Deviation:", round(age_sd,1), "years")

bp_range <- range(training_set$trestbps)
bp_iqr <- IQR(training_set$trestbps)
bp_var <- var(training_set$trestbps)
bp_sd <- sd(training_set$trestbps)
cat("\n\nNormalized Blood Pressure Spread:\n",
    "Range:", bp_range[1], "-", bp_range[2], "(0-1 scale)\n",
    "IQR:", round(bp_iqr,4), "(middle 50% range)\n",
    "Variance:", round(bp_var,5), "\n",
    "Standard Deviation:", round(bp_sd,3))



mean_age <- mean(test_set$age)
median_age <- median(test_set$age)
age_table <- table(test_set$age)
mode_age <- as.numeric(names(age_table)[which.max(age_table)])
cat("Patient Age:\n",
    "Mean:", round(mean_age,1), "years\n",
    "Median:", median_age, "years\n",
    "Mode:", mode_age, "years\n")


diag_table <- table(test_set$diagnosis)
mode_diag <- names(diag_table)[which.max(diag_table)]
cat("\nDiagnosis Distribution:\n",
    "Most common:", mode_diag, "\n",
    "Healthy vs Disease:\n")
print(diag_table)


mean_chol <- mean(test_set$chol)
median_chol <- median(test_set$chol)
chol_table <- table(round(test_set$chol,2))
mode_chol <- as.numeric(names(chol_table)[which.max(chol_table)])
cat("\nNormalized Cholesterol:\n",
    "Mean:", round(mean_chol,3), "\n",
    "Median:", round(median_chol,3), "\n",
    "Mode:", round(mode_chol,3), "\n",
    "(0 = min, 1 = max cholesterol)")


cp_table <- table(test_set$cp)
mode_cp <- names(cp_table)[which.max(cp_table)]
cat("\nChest Pain Types:\n",
    "Most common:", mode_cp, "\n",
    "Full distribution:\n")
print(cp_table)


age_range <- range(test_set$age)
age_iqr <- IQR(test_set$age)
age_var <- var(test_set$age)
age_sd <- sd(test_set$age)
cat("Age Spread Metrics:\n",
    "Range:", age_range[1], "-", age_range[2], "years\n",
    "IQR:", age_iqr, "years (middle 50% range)\n",
    "Variance:", round(age_var,1), "\n",
    "Standard Deviation:", round(age_sd,1), "years")


bp_range <- range(test_set$trestbps)
bp_iqr <- IQR(test_set$trestbps)
bp_var <- var(test_set$trestbps)
bp_sd <- sd(test_set$trestbps)
cat("\n\nNormalized Blood Pressure Spread:\n",
    "Range:", bp_range[1], "-", bp_range[2], "(0-1 scale)\n",
    "IQR:", round(bp_iqr,4), "(middle 50% range)\n",
    "Variance:", round(bp_var,5), "\n",
    "Standard Deviation:", round(bp_sd,3))

