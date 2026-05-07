# 📖 Overview
TEMPO (Tumor Ecosystem Modeling for Predictive Outcomes) is a multi-scale, deterministic modeling framework designed to predict treatment response in triple-negative breast cancer (TNBC).

TEMPO integrates:
- Single-cell Imaging Mass Cytometry (IMC) data
- Mechanistic mathematical modeling (ODE-based) Machine learning for outcome prediction

The framework enables patient-specific simulation of tumor–immune–stromal dynamics under therapy and supports prediction of:
- Pathologic complete response (pCR)
- Residual disease (RD)

  
# 🧠 Conceptual Workflow

TEMPO follows a five-stage pipeline:
## 🔹 Stage 1 — Single-Cell Phenotyping
- IMC data processing
- Cell-type identification (tumor, immune, stromal compartments)
- Dimensionality reduction and clustering
  
## 🔹 Stage 2 — Mathematical Modeling
- ODE-based system modeling tumor ecosystem dynamics
- Captures:
    - Tumor growth
    - Immune interactions
    - Stromal contributions
    - Therapy effects
      
## 🔹 Stage 3 — Predictive Modeling
- Feature extraction from model outputs
- Machine learning classification:
    - pCR vs RD
- 5-fold cross-validation
- Feature importance analysis
  
## 🔹 Stage 4 — Sensitivity Analysis
- Patient-specific (local) sensitivity
- Global cohort-level sensitivity
- Identification of key regulatory parameters
  
## 🔹 Stage 5 — In Silico “What-If” Simulations
- Treatment perturbation simulations
- Parameter tuning
- Prediction of outcome shifts (RD → pCR)
  
# ✨ Requirements
- MATLAB (R2020a or later recommended)
- AMIGO_2 MATLAB toolbox
- R (≥ 4.2.0 recommended)

# 🔁 Reproducibility Notes
Detailed instructions for reproducing patient-level simulations are provided within the respective cohort-specific folders:
- /chemo_treated_simulations
- /chemo_immunotherapy_treated_simulations

### 👉 Users should refer to the README.txt files within these folders for:
- Patient-specific simulation workflows
- Execution of Run_[PatientID].m scripts
- Goodness-of-fit evaluation
- Generation and interpretation of simulation outputs
### These folder-level instructions provide step-by-step guidance tailored to each treatment cohort, ensuring accurate reproduction of all simulation results presented in this study.
