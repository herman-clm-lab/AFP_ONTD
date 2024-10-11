# Evaluation of Inclusion of Race in msAFP ONTD Risk Stratification

<!-- start overview -->

Code repository for the evaluation of the inclusion of race in maternal serum alpha-fetoprotein (AFP) testing for open neural tube (ONTD) risk stratification

## Introduction
This repos was to process and analyze AFP testing data for ONTD risk stratification. Data was collected for singleton pregancies between 15 and 21 weeks gestation who underwent AFP ONTD screening between 1/1/2020 and 3/25/2024.

This repos accompanies submitted manuscript entitled "Reassessing Inclusion of Race in Laboratory Screening for Open Neural Tube Defects".

<!-- end overview -->

## Contact

Analyses were performed by [William Butler](mailto:William.Butler@Pennmedicine.upenn.edu), Rebecca Ramesh, and [Dan Herman](mailto:daniel.herman2@pennmedicine.upenn.edu). Please reach out with any questions or comments.

Additional contributors:

- Christina Pierre
- Jonathan Von Reusner
- Sindhu Srinivas

## Organization
```.
├── LICENSE
├── R
├── README.md
├── data
├── msAFP.Rproj
├── notebooks
│   ├── msAFP_load_data.Rmd
│   ├── msAFP_train_models.Rmd
├── output
└── sql
    └── pull_msAFP_CERNER.sql
```

## Usage
### Load data
`msAFP_load_data.Rmd`: Load laboratory data, perform data cleaning, and apply inclusion/exclusion criteria

Inclusion criteria:
- `Estimated delivery date` is non-missing
- `Gestational age` is between 15.0 and 21.6 weeks
- `AFP` is non-missing
- `Weight` is non-missing and between 50 and 800 (lbs)
- First study of pregnancy (in data)
- First pregnancy (in data)
- `AFP` in multiple sources match
- `Number of fetuses` is 1 or 2 (insufficient data to confirm performance for 3+)

### Modeling and analysis
`msAFP_train_models.Rmd`: Train models, calculate AFP MoMs

Input data was restricted to singleton pregnancies and non-missing diabetes status

Multiple models were trained to predict population median/mean AFP concentrations. We compared models that did or did not include race and/or ethnicity as a predictor.

## Environment
- R 4.4.0
- Packages:
```
Package   Version
boot       1.3-30
broom       1.0.6
glue        1.7.0
lubridate   1.9.3
patchwork   1.2.0
quantreg     5.98
rlang       1.1.3
tidyverse   2.0.0
yardstick   1.3.1
```