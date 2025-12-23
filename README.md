# Real Estate Price Analysis — Taipei MRT Proximity

## Overview

This project analyzes the relationship between residential real estate prices and proximity to MRT (Mass Rapid Transit) stations in New Taipei City, Taiwan. Using historical housing transaction data, the study explores linear, log-linear, log-log, and multivariable regression models to understand how accessibility, location, and neighborhood features affect housing prices.

The analysis emphasizes model selection, statistical inference, and diagnostic testing, following standard econometric practices.

## Dataset

Source: Real estate valuation dataset from Sindian District, New Taipei City, Taiwan

Observations: 414 transactions

Target variable:

- House price per unit area (10,000 New Taiwan Dollar per Ping; 1 Ping = 3.3 m²)

Key features:

- Transaction date (e.g., 2013.250 = March 2013)
- House age (years)
- Distance to nearest MRT station (meters)
- Number of convenience stores nearby
- Geographic coordinates (latitude, longitude)

## Methodology

### 1. Simple linear regression

- Examines the relationship between distance to MRT and house price
- Finds a statistically significant negative relationship
- Distance explains ~45% of price variance

### 2. Log-log regression

- Addresses skewness and non-linearity in the data
- Produces a better fit (R² ≈ 57%)
- Interpretable elasticity:
	- A 1% increase in distance from MRT → ~0.27% decrease in house price

### 3. Multivariable regression

Additional explanatory variables included:

- Transaction date
- Number of convenience stores (square-root transformed)
- Latitude and longitude

Results:

- Improved explanatory power (Adjusted R² ≈ 69%)
- Distance to MRT remains the most influential variable
- Location and neighborhood amenities significantly affect prices

## Model diagnostics

- Heteroskedasticity: Detected in simpler models, improved with multivariable specification
- Autocorrelation: Tested using ACF and residual plots
- Normality: Evaluated via residual histograms and Jarque–Bera tests
- Collinearity: Checked using VIF (no severe multicollinearity)
- RESET test: Used to evaluate functional form; higher-order terms tested but rejected for parsimony

## Key findings

- Proximity to MRT stations has a strong, economically meaningful impact on housing prices
- Log-log specifications better capture diminishing marginal effects
- Incorporating spatial and neighborhood variables significantly improves model performance
- The final multivariable model balances interpretability and goodness-of-fit

## Tools & techniques

- Ordinary Least Squares (OLS)
- Log and square-root transformations
- Regression diagnostics (AIC, BIC, RESET, VIF)
- Residual analysis and hypothesis testing

## Repository contents

- `assign.R` — R script for the analysis
- `Roshan_Surabhi_2018AAPS0391H.pdf` — report/output
