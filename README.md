# Statistical alignment in EAC secondary data analyses

Reproducibility materials for:

**Structure, estimand, method and reporting in contemporary secondary analyses of DHS, MICS and DHIS2 data in the East African Community: systematic meta-research with a prespecified empirical illustration**

Authors:
- TUYISHIME AUDRE PRINCE, University of Rwanda
- Patrick Kayinamura Muhirwa, Rwanda Biomedical Centre

Protocol registration: https://osf.io/89mk7/

## Repository contents

### analysis/
Design-weighted analysis of the frozen 127-publication probability sample:
- clean derived analysis dataset
- reliability dataset
- frozen stratum metadata
- complete R reproduction script
- output tables, session information and monochrome figures
- Supplementary Table S6 descriptive D1-D4 cross-tabs
- Supplementary Table S7 search and candidate-frame audit

### validation/
Prespecified Rwanda DHS empirical illustration (the directory name is retained for provenance):
- pre-access frozen validation specification
- R analysis and plotting scripts
- aggregate validation outputs
- independent re-verification note

## Restricted material

This repository does **not** contain:
- copyrighted article full texts
- respondent-level Rwanda DHS microdata
- direct identifiers or restricted data

Rwanda DHS microdata must be requested independently from The DHS Program and used subject to its terms of use. The empirical-illustration scripts read authorized local microdata but only aggregate, non-disclosive outputs are included here.

## Reproduction

Run the literature analysis from the `analysis/` directory:

```bash
Rscript paper2_reproduce_all_final_analysis.R
```

The Rwanda empirical illustration requires locally authorized RDHS files and is documented in `validation/RDHS_VALIDATION_SPEC_v1.0_FROZEN_2026-10-13.md`.

Exact package versions are recorded in the relevant `R_sessionInfo.txt` files.

## Version used for journal submission

The current hardened journal-submission snapshot is identified by the immutable commit cited in the manuscript Data Availability Statement. The earlier **v1.0.0** tag is retained as a provenance checkpoint from before the final hostile-review hardening pass.

## Licence

R code is released under the MIT License. Derived aggregate tables and documentation may be reused with attribution. Third-party source data remain subject to their original licences and access conditions.
