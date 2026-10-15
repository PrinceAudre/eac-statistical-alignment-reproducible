# Statistical alignment in EAC secondary data analyses

Reproducibility materials for:

**Structure, estimand, method and reporting in contemporary secondary analyses of DHS, MICS and DHIS2 data in the East African Community: systematic meta-research with a prespecified empirical illustration**

Authors:
- TUYISHIME AUDRE PRINCE, University of Rwanda
- Patrick Kayinamura Muhirwa, Rwanda Biomedical Centre

Protocol registration: https://osf.io/89mk7/

## Repository contents

### analysis/
Search reproducibility: exact PubMed and Scopus/Publish or Perish strategies, validation history, export hashes, deduplication, and DHS Program supplementary-search audit are in `analysis/search_audit/`.

Primary analysis is the design-weighted analysis of the frozen 127-publication probability sample. A later DHIS2 census exercise is retained only as an exploratory audit record and is not used for primary inference or substantive conclusions. Some non-primary records could not be assessed from complete accessible full text, so no abstract-only methodological outcome is forced.

Primary analysis materials:
- clean derived analysis dataset
- reliability dataset
- frozen stratum metadata
- complete R reproduction script
- output tables, session information and monochrome figures
- Supplementary Table S6 descriptive D1-D4 cross-tabs
- Supplementary Table S7 search and candidate-frame audit
- script for Supplementary Figure S2 identification and screening flow

### validation/
Prespecified Rwanda DHS empirical illustration (the directory name is retained for provenance):
- manuscript-facing Figure 3 aliases: `outputs/Figure3_RDHS_empirical_illustration_precision.{eps,png}`
- legacy `validation`-named figure files are retained only for provenance
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


## Submission-facing supplementary artifacts

The manuscript-facing supplement is mapped directly to repository files:

- Supplementary Figure S1: `analysis/outputs/Supplementary_Figure_S1_sentinel_indicators.*`
- Supplementary Figure S2: `analysis/outputs/Supplementary_Figure_S2_PRISMA_flow.svg`
- Supplementary Table S1: `analysis/Supplementary_Table_S1_Stratum_Allocation.csv`
- Supplementary Table S2: `analysis/Supplementary_Table_S2_Full_Text_Exclusion_Reasons.csv`
- Supplementary Table S3: `analysis/Supplementary_Table_S3_Reliability.csv`
- Supplementary Table S4: `analysis/Supplementary_Table_S4_Sentinel_Indicators.csv`
- Supplementary Table S5: `analysis/Supplementary_Table_S5_Sensitivity_Analyses.csv`
- Supplementary Table S6: `analysis/Supplementary_Table_S6_Domain_CrossTabs_2026-10-13.csv`
- Supplementary Table S7: `analysis/Supplementary_Table_S7_Search_Frame_Audit_2026-10-13.csv`, with exact search companion files under `analysis/search_audit/`.
