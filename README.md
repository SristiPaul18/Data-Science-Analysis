# Heart Disease Data Preprocessing

This repository contains the implementation of data preprocessing techniques applied to the Heart Disease dataset. The dataset was originally sourced from [Kaggle](https://www.kaggle.com/datasets/redwankarimsony/heart-disease-data) and has been modified for the purpose of preprocessing.

## Overview

The Heart Disease dataset contains medical information for individuals, and is commonly used for predicting the presence of heart disease. It includes features such as age, sex, blood pressure, cholesterol levels, and others, along with a target variable indicating whether the individual has heart disease.

In this repository, various preprocessing steps are applied to the dataset to clean, format, and prepare the data for machine learning tasks. These steps include handling missing values, outlier treatment, categorical encoding, normalization, and data augmentation.

## Dataset

The dataset used in this project is based on the heart disease data available on Kaggle. The original dataset was modified to facilitate data preprocessing tasks, including the handling of missing values, outliers, and invalid data entries.

### Key Features:

* `age`: Age of the individual
* `sex`: Gender of the individual (1 = Male, 0 = Female)
* `cp`: Chest pain type
* `trestbps`: Resting blood pressure
* `chol`: Serum cholesterol levels
* `fbs`: Fasting blood sugar (1 = True, 0 = False)
* `restecg`: Resting electrocardiographic results
* `thalach`: Maximum heart rate achieved
* `exang`: Exercise induced angina (1 = Yes, 0 = No)
* `oldpeak`: Depression induced by exercise relative to rest
* `slope`: Slope of the peak exercise ST segment
* `ca`: Number of major vessels colored by fluoroscopy
* `thal`: Thalassemia (3 = Normal, 6 = Fixed defect, 7 = Reversable defect)
* `num`: Diagnosis (0 = No heart disease, 1 = Heart disease)

## Data Preprocessing Steps

The following preprocessing steps were applied to prepare the dataset for further analysis and model building:

### 1. **Handling Missing Values**

* **Detection**: Missing values were identified in the dataset using common methods, including checking for `NA` values and empty strings.
* **Imputation**: Missing values were imputed with the following strategies:

  * For the `age` column, missing values were replaced with the column mean.
  * For the `ca` column, missing values were replaced with the mode.
  * For the `thal` column, missing values were replaced with the mode.

### 2. **Outlier Detection and Handling**

* **Detection**: Outliers were detected using the Interquartile Range (IQR) method on columns like `age`, `trestbps`, `chol`, `thalach`, and `oldpeak`.
* **Handling**: Outliers were replaced with the median of the respective column to prevent distortion in the dataset.

### 3. **Categorical Encoding**

* **Encoding Categorical Variables**: Categorical columns (`thal` and `num`) were encoded into numeric values for model compatibility:

  * The `thal` column was transformed into numeric values representing different thalassemia types (1, 2, 3).
  * The `num` column was converted into binary form, with "No" (0) and "Yes" (1) indicating the presence of heart disease.

### 4. **Normalization**

* **Feature Scaling**: Continuous columns such as `trestbps`, `chol`, `oldpeak`, and `thalach` were normalized using min-max normalization, scaling the values to a range between 0 and 1.

### 5. **Duplicate Removal**

* **Removing Duplicates**: Duplicate rows were identified and removed to ensure the dataset contains only unique records.

### 6. **Data Filtering**

* **Filtering**: Rows were filtered based on specific criteria (e.g., age > 60, cholesterol > 0.7, diagnosis indicating heart disease) to create a refined subset for analysis.

### 7. **Handling Invalid Values**

* **Data Validation**: Invalid entries were detected in certain columns (e.g., `sex` column where "F" was replaced with "Female") and corrected accordingly.

### 8. **Synthetic Data Augmentation**

* **Data Generation**: Synthetic data was generated to simulate new patient records, ensuring the statistical properties of the data remain intact.

### 9. **Dataset Splitting**

* **Train-Test Split**: The dataset was split into a training set (70%) and a testing set (30%) to facilitate machine learning model training and evaluation.

## Requirements

To run the preprocessing code, the following software and libraries are required:

* **R (version 4.0 or higher)**
* **dplyr package** (for data manipulation)

Install the required package with:

```R
install.packages("dplyr")
```

## How to Run the Code

1. Clone or download this repository to your local machine.
2. Open the `heart_disease_preprocessing.R` script in an R environment.
3. Update the path to the dataset file (`heart_disease_uci - modified.csv`).
4. Execute the script to perform all the preprocessing steps.

## Conclusion

This preprocessing pipeline ensures that the Heart Disease dataset is clean, normalized, and ready for machine learning models. The steps outlined above help prepare the data by handling missing values, correcting outliers, encoding categorical features, and splitting the dataset for training and testing.
