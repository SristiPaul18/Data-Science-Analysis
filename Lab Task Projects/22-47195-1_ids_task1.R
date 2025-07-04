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
print(colnames(data))

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


gradient_colors <- colorRampPalette(c("mediumpurple", "royalblue", "navy"))(15)
hist(data$Age, 
     main="Age", 
     xlab="Age", 
     col=gradient_colors, 
     border="white",  
     col.main="darkred", 
     col.lab="navy")

hist(data$SleepDuration, 
     main="Sleep Duration (hours)", 
     xlab="Sleep Duration", 
     col=gradient_colors, 
     border="white", 
     col.main="darkred", 
     col.lab="navy")

hist(data$QualityOfSleep, 
     main="Quality of Sleep", 
     xlab="Quality of Sleep", 
     col=gradient_colors, 
     border="white", 
     col.main="darkred", 
     col.lab="navy")

hist(data$PhysicalActivity, 
     main="Physical Activity (minutes/day)", 
     xlab="Physical Activity", 
     col=gradient_colors, 
     border="white", 
     col.main="darkred", 
     col.lab="navy")

hist(data$StressLevel, 
     main="Stress Level", 
     xlab="Stress Level", 
     col=gradient_colors, 
     border="white", 
     col.main="darkred", 
     col.lab="navy")

hist(data$Systolic, 
     main="Systolic Blood Pressure", 
     xlab="Systolic (mm Hg)", 
     col=gradient_colors, 
     border="white", 
     col.main="darkred", 
     col.lab="navy")

hist(data$Diastolic, 
     main="Diastolic Blood Pressure", 
     xlab="Diastolic (mm Hg)", 
     col=gradient_colors, 
     border="white", 
     col.main="darkred", 
     col.lab="navy")

hist(data$HeartRate, 
     main="Heart Rate (bpm)", 
     xlab="Heart Rate", 
     col=gradient_colors, 
     border="white", 
     col.main="darkred", 
     col.lab="navy")

hist(data$DailySteps, 
     main="Daily Steps", 
     xlab="Daily Steps", 
     col=gradient_colors, 
     border="white", 
     col.main="darkred", 
     col.lab="navy")



soft_colors <- c("firebrick", "dodgerblue", "darkorange", "limegreen")
counts_gender <- table(data$Gender)

barplot(counts_gender,
        col = soft_colors[1:length(counts_gender)],
        border = "white",
        main = "Gender Distribution",
        xlab = "Gender",
        ylab = "Count",
        col.main = "darkred",
        col.lab = "navy")

counts_occupation <- table(data$Occupation)
barplot(counts_occupation,
        col = soft_colors[1:length(counts_occupation)],
        border = "white",
        main = "Occupation Distribution",
        xlab = "Occupation",
        ylab = "Count",
        col.main = "darkred",
        col.lab = "navy")

counts_bmi <- table(data$BMICategory)
barplot(counts_bmi,
        col = soft_colors[1:length(counts_bmi)],
        border = "white",
        main = "BMI Category Distribution",
        xlab = "BMI Category",
        ylab = "Count",
        col.main = "darkred",
        col.lab = "navy")     

counts_sleep <- table(data$SleepDisorder)
barplot(counts_sleep,
        col = soft_colors[1:length(counts_sleep)],
        border = "white",
        main = "Sleep Disorder Distribution",
        xlab = "Sleep Disorder",
        ylab = "Count",
        col.main = "darkred",
        col.lab = "navy")


numeric_cols <- c("Age", "SleepDuration", "QualityOfSleep", "PhysicalActivity", "StressLevel",
                  "Systolic", "Diastolic", "HeartRate", "DailySteps")

x_colors <- c("tomato3", "darkorange2", "mediumpurple", "chartreuse4", 
              "royalblue3", "firebrick3", "magenta3", "darkcyan", "goldenrod3")
color_map <- setNames(x_colors, numeric_cols)
numeric_data <- data[, numeric_cols]

for (i in 1:(length(numeric_cols) - 1)) 
{
  for (j in (i + 1):length(numeric_cols)) 
  {
    x_var <- numeric_cols[i]
    y_var <- numeric_cols[j]
    
    plot(numeric_data[[x_var]], numeric_data[[y_var]],
         xlab = x_var,
         ylab = y_var,
         main = paste(x_var, "vs", y_var),
         pch = 18,         
         col = color_map[[x_var]],
         col.main = "darkred",
         col.lab = "navy")
    
    readline(prompt = "Press Enter for next plot.")
  }
}

pairs(numeric_data,
      col = "tomato3",
      pch = 18,
      main = "Scatterplot Matrix of Numeric Variables",
      cex.labels = 1.2,
      font.labels = 2,
      col.main = "darkred",
      col.lab = "navy")


cols <- c("hotpink", "dodgerblue")
for (var in numeric_cols) 
{
  p <- ggplot(data, aes_string(x = "Gender", y = var, fill = "Gender")) +
    geom_violin(trim = FALSE, color = "black", alpha = 0.8) +
    geom_boxplot(width = 0.1, fill = "white") +
    scale_fill_manual(values = cols) +
    labs(title = paste("Violin plot of", var, "by Gender")) +
    theme_minimal() +
    theme(
      legend.position = "none",
      plot.title = element_text(color = "darkred", size = 12, face = "bold"),
      axis.title = element_text(color = "navy", size = 12)
    )
  
  print(p)
  readline("Press Enter for next plot.")
}


cols <- c("darkorange", "orangered", "firebrick", "darkred")
for (var in numeric_cols) 
{
  p <- ggplot(data, aes_string(x = "Occupation", y = var, fill = "Occupation")) +
    geom_violin(trim = FALSE, color = "black", alpha = 0.8) +
    geom_boxplot(width = 0.1, fill = "white") +
    scale_fill_manual(values = cols) +
    labs(title = paste("Violin plot of", var, "by Occupation")) +
    theme_minimal() +
    theme(
      legend.position = "none",
      plot.title = element_text(color = "darkred", size = 12, face = "bold"),
      axis.title = element_text(color = "navy", size = 12)
    )
  
  print(p)
  readline("Press Enter for next plot.")
}

cols <- c("limegreen", "chartreuse4", "cadetblue", "mediumturquoise")
for (var in numeric_cols) 
{
  p <- ggplot(data, aes_string(x = "BMICategory", y = var, fill = "BMICategory")) +
    geom_violin(trim = FALSE, color = "black", alpha = 0.85) +
    geom_boxplot(width = 0.1, fill = "white") +
    scale_fill_manual(values = cols) +
    labs(title = paste("Violin plot of", var, "by BMICategory")) +
    theme_minimal() +
    theme(
      legend.position = "none",
      plot.title = element_text(color = "darkred", size = 12, face = "bold"),
      axis.title = element_text(color = "navy", size = 12)
    )
  
  print(p)
  readline("Press Enter for next plot.")
}


cols <- c("mediumpurple", "royalblue", "navy")

for (var in numeric_cols) 
{
  p <- ggplot(data, aes_string(x = "SleepDisorder", y = var, fill = "SleepDisorder")) +
    geom_violin(trim = FALSE, color = "black", alpha = 0.8) +
    geom_boxplot(width = 0.1, fill = "white") +
    scale_fill_manual(values = cols) +
    labs(title = paste("Violin plot of", var)) +
    theme_minimal() +
    theme(
      legend.position = "none",
      plot.title = element_text(color = "darkred", size = 12, face = "bold"),
      axis.title = element_text(color = "navy", size = 12)
    )
  
  print(p)
  readline("Press Enter for next plot.")
}

