# Chemo-Treated Simulations

## Overview

This folder contains MATLAB scripts and simulation outputs used to model the temporal dynamics of chemotherapy-treated patients included in this study.

The mathematical modeling workflow was implemented using custom MATLAB scripts developed within the AMIGO_2 MATLAB toolbox framework. This folder is organized to support patient-specific simulations, goodness-of-fit evaluation, and downstream comparison of chemotherapy response groups.

---

## Folder Contents

### 1. Patient-Specific Mathematical Model Files

Patient-specific MATLAB model files define the mathematical model for each chemotherapy-treated patient.

**File naming format:**

```text
[PatientID].m
```

**Example:**

```text
NT152.m
```

Each patient-specific model file contains the model structure used to simulate that patient’s tumor or treatment-response dynamics, including model equations, parameters, and initial conditions.

---

### 2. Patient-Specific Simulation Runner Files

Each patient model has a corresponding MATLAB runner script used to call the patient-specific model file and simulate its dynamics.

**File naming format:**

```text
Run_[PatientID].m
```

**Example:**

```text
Run_NT152.m
```

These files are used to:

- Load the corresponding patient-specific model
- Run the mathematical simulation
- Generate patient-level dynamic outputs
- Support downstream analysis and comparison across patients

---

### 3. Goodness-of-Fit Analysis

This folder contains a MATLAB script named:

```text
goodness_of_fit.m
```

This script is used to calculate and simulate the goodness of fit between observed and model-predicted values across all available timepoints.

The goodness-of-fit analysis supports evaluation of model performance across chemotherapy-treated patients and helps assess how well the mathematical simulations capture patient-specific dynamics.

---

### 4. Simulation Results

Simulation results are provided as CSV files for chemotherapy-treated patients.

The output files include:

- Simulation results for all chemotherapy-treated patients
- Stratified simulation results for residual disease patients
- Stratified simulation results for patients who achieved pathologic complete response

The stratified outputs support comparison of dynamic model behavior between clinically distinct response groups.

---

### 5. Fitted Dynamic Parameter Simulation Files

This folder also contains MATLAB files ending with:

```text
FT.m
```

These files were used to simulate the fitted dynamic parameters from the patient-specific mathematical simulations.

The `FT.m` files support downstream analysis of patient-level dynamic parameters and allow comparison of fitted model behavior across chemotherapy-treated patients.

---

## Recommended Workflow

### Step 1: Run an individual patient simulation

Open MATLAB and run the corresponding patient simulation file:

```matlab
Run_NT152
```

Replace `NT152` with the appropriate patient identifier.

---

### Step 2: Evaluate model goodness of fit

Run the goodness-of-fit script:

```matlab
goodness_of_fit
```

This will calculate model fit across available timepoints and compare simulated outputs with observed data.

---

### Step 3: Review simulation outputs

Review the generated CSV output files for:

- All chemotherapy-treated patients
- Residual disease patients
- Pathologic complete response patients

These files can be used for downstream visualization, statistical comparison, and biological interpretation.

---

## File Naming Summary

| File Type | Naming Format | Description |
|---|---|---|
| Patient model file | `[PatientID].m` | Defines the mathematical model for an individual patient |
| Simulation runner file | `Run_[PatientID].m` | Calls the patient model file and runs the simulation |
| Goodness-of-fit file | `goodness_of_fit.m` | Calculates goodness of fit across timepoints |
| Fitted parameter simulation file | `*FT.m` | Simulates fitted dynamic parameters |
| Simulation output | `.csv` | Contains simulated results for all and stratified chemotherapy-treated patients |

---

## Reproducibility Notes

To reproduce the chemotherapy-treated patient simulations:

1. Install MATLAB.
2. Install and configure the AMIGO_2 MATLAB toolbox.
3. Add the AMIGO_2 toolbox and this folder to the MATLAB path.
4. Run the relevant `Run_[PatientID].m` script.
5. Run `goodness_of_fit.m` to evaluate model performance.
6. Use the CSV simulation outputs for downstream analysis.

The AMIGO_2 toolbox itself is not redistributed in this repository. Users should obtain AMIGO_2 from its official source and cite the appropriate AMIGO_2 publication.

---

## Summary

This folder provides the chemotherapy-treated patient simulation module for the study. It includes patient-specific mathematical models, simulation runner scripts, goodness-of-fit evaluation, fitted dynamic parameter simulations, and CSV outputs for all chemotherapy-treated patients and clinically stratified response groups.
