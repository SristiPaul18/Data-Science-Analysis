# Heart Disease Dataset Documentation

## Original Dataset
**Source**: [UCI Heart Disease Dataset on Kaggle](https://www.kaggle.com/datasets/redwankarimsony/heart-disease-data)  
**Records**: 303 total (216 from Cleveland Clinic used in this project)  
**Time Period**: Collected 1988  
**Purpose**: Predict presence of heart disease (angiographic disease status)

## Key Features
| Feature | Type | Description | Clinical Relevance |
|---------|------|-------------|--------------------|
| age | Numerical | Patient age in years | Risk increases with age |
| sex | Binary | 1 = male, 0 = female | Gender risk factors |
| cp | Categorical | Chest pain type (4 values) | Angina characteristics |
| trestbps | Numerical | Resting blood pressure (mmHg) | Hypertension marker |
| chol | Numerical | Serum cholesterol (mg/dL) | Hyperlipidemia indicator |
| fbs | Boolean | Fasting blood sugar >120 mg/dL | Diabetes screening |
| restecg | Categorical | Resting ECG results (3 values) | Heart electrical activity |
| thalach | Numerical | Maximum heart rate achieved | Exercise tolerance |
| exang | Boolean | Exercise induced angina (1=yes) | Coronary artery disease sign |
| oldpeak | Numerical | ST depression induced by exercise | Ischemia indicator |
| slope | Categorical | Slope of peak exercise ST segment | ECG pattern analysis |
| ca | Numerical | Number of major vessels (0-3) | Angiographic severity |
| thal | Categorical | Thalassemia type (3 values) | Blood disorder effect |
| num | Binary | Diagnosis (0=<50% diameter narrowing, 1=>50%) | Target variable |

## Dataset Characteristics
1. **Multivariate** (13 clinical features + target)
2. **Mixed Data Types**:
   - Continuous (age, trestbps, chol, thalach, oldpeak)
   - Ordinal (ca)
   - Nominal (cp, restecg, slope, thal)
   - Binary (sex, fbs, exang, num)

3. **Class Distribution** (Original):
   - No Heart Disease (num=0): 164 (54%)
   - Heart Disease (num=1): 139 (46%)

## Data Collection Methodology
- Collected at Cleveland Clinic Foundation
- Angiographic examination as gold standard
- Exercise ECG testing results
- Demographic/risk factor questionnaires
- Laboratory blood tests

## Known Limitations (Original Data)
1. Missing values (particularly in 'ca' and 'thal')
2. Small sample size for some categories
3. Potential measurement variability across clinicians
4. Older dataset (1988) - treatment norms may have changed
