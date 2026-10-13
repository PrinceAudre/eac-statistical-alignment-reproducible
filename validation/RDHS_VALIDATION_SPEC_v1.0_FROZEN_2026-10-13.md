# Paper 2 Rwanda validation specification v1.0

**Status:** FROZEN BEFORE RDHS 2025 MICRODATA ACCESS  
**Freeze date:** 2026-10-13  
**Protocol basis:** Paper 2 frozen protocol v0.2, blob `82375064d1feba05502ed69f5ccf407c3da62a14`  
**Target journal:** Journal of the Royal Statistical Society Series A: Statistics in Society

## 1. Purpose

This module tests the inferential consequences of two prespecified DHS design misalignments identified from the completed Paper 2 literature audit. It does not discover, redefine, or rescore the methodological framework.

The module uses Rwanda DHS 2019-20 as an established benchmark and Rwanda DHS 2025 as an out-of-sample new-survey validation.

No epidemiological effect is pooled across survey waves.

## 2. Timing and information available at freeze

At the time of this freeze:

- the literature audit, detailed coding, reliability study, and design-weighted literature analysis were complete;
- the Paper 2 literature results were known;
- separate Paper 1 work had already exposed the investigators to aggregate RDHS 2019-20 design-validation results;
- public RDHS 2025 documentation and public data-dictionary metadata had been inspected only to establish file/variable availability and survey comparability;
- RDHS 2025 microdata bytes had **not** been downloaded, opened, queried, summarized, modeled, or otherwise analysed for Paper 2.

The RDHS 2025 validation therefore remains out of sample with respect to the numerical validation outcomes.

Any change to the scenarios, variables, estimands, comparison analyses, or metrics below after RDHS 2025 microdata access requires a dated amendment stating the reason, timing, and affected outputs.

## 3. Literature-result basis for scenario selection

The completed DHS/MICS audit showed that design handling was a recurrent confirmed or unresolved issue:

- prespecified sentinel P1, complex survey treated as simple random sample: estimated confirmed prevalence 16.0%; unclear 45.3%;
- survey-variance item classified inappropriate: 12.6%; unclear 46.2%;
- survey-weight item classified inappropriate: 2.5%; unclear 40.0%.

The validation therefore focuses on the consequences of treating a designed DHS sample as if it were simpler than its documented sampling process.

The lower confirmed prevalence of explicit weight misuse does not make it a primary prevalence claim. Weight omission is retained as the severe comparison analysis needed to separate point-estimate consequences from the variance-only consequences of omitting cluster/stratum structure.

## 4. Selected misalignments

### M1. Unweighted simple-random-sample analysis

The analysis ignores DHS sampling weights and the PSU/stratum sampling structure.

For a national descriptive estimand, this can change both the point estimate and its uncertainty. For regression, it can change both coefficients and uncertainty.

### M2. Weights-only analysis with PSU/stratum structure omitted

The analysis uses the DHS woman sampling weight but treats observations as independent for variance estimation.

This comparison is intended to isolate the uncertainty-estimation consequence of omitting clustering and stratification after the weighted point estimand has been recovered.

## 5. Surveys and files

### Benchmark survey
Rwanda DHS 2019-20, Individual Women Recode:
- expected recode family: `RWIR81`
- restricted microdata remain outside GitHub.

### Out-of-sample validation survey
Rwanda DHS 2025, Individual Women Recode:
- public metadata file name: `RWIR91FL`
- public metadata reports 14,283 cases;
- required common variables are documented in the public data dictionary.

Only authorised local copies may be opened. Restricted microdata are never committed or redistributed.

## 6. Common analytic universe and variables

The same analytic definitions are used in both surveys.

### Analytic universe
Interviewed women aged 15-49 represented in the Individual Women Recode with:
- valid positive woman sample weight;
- non-missing PSU;
- non-missing sampling-error stratum;
- non-missing health-insurance status.

No age restriction beyond the standard IR universe is introduced.

### Survey design
- weight: `v005 / 1e6`
- PSU: `v021`
- sampling-error stratum: `v022`
- design is declared with `nest=TRUE`.

The script must fail if a full-sample stratum contains fewer than two observed PSUs. No lonely-PSU adjustment will be selected after seeing validation results.

### Outcome
Any health-insurance coverage:
- source variable: `v481`
- insured = 1 when `v481 == 1`
- insured = 0 when `v481 == 0`
- system missing or any unexpected non-binary value is excluded/fails validation as appropriate.

### Regression exposure
Highest educational level:
- source variable: `v106`
- 0 = no education
- 1 = primary
- 2 = secondary
- 3 = higher
- no education is the reference category.

No additional regression covariates will be added.

## 7. Validation Scenario V1: national health-insurance prevalence

### Estimand
For each survey wave separately, the national proportion of women aged 15-49 with any health insurance among women with observed `v481`.

### Reference analysis
Full design-based analysis:
- `ids = ~v021`
- `strata = ~v022`
- `weights = ~v005/1e6`
- `nest = TRUE`
- proportion confidence interval: `survey::svyciprop(..., method="logit")`.

### M1 comparison
Unweighted simple-random-sample analysis:
- `ids = ~1`
- no sampling weights.

### M2 comparison
Weights-only analysis:
- `ids = ~1`
- `weights = ~v005/1e6`
- no PSU/stratum structure.

### Metrics
For all three analyses:
- point estimate;
- standard error;
- 95% confidence interval;
- confidence-interval width.

For M1 and M2 relative to the reference:
- absolute point-estimate difference in percentage points;
- standard-error ratio;
- variance ratio;
- confidence-interval width ratio.

The module will report the numerical consequences directly. No post hoc threshold will be invented to label a prevalence difference "important."

### 2019-20 known-answer gates
Before any cross-method comparison is accepted, the full-design 2019-20 analysis must reproduce:
- health-insurance prevalence 82.6% within 0.15 percentage points;
- weighted N 14,634 within one person after rounding;
- 500 unique PSUs;
- 60 sampling-error strata.

Failure closes the gate and requires code/data-definition review before proceeding.

### 2025 structural gate
The authorised 2025 IR file must:
- contain exactly 14,283 rows, matching public catalog metadata;
- contain `v005`, `v021`, `v022`, `v106`, and `v481`;
- contain 560 unique PSUs, matching the published survey design;
- pass all coding and positive-weight checks.

No 2025 outcome value is specified in advance.

## 8. Validation Scenario V2: education and health-insurance association

### Estimand
Within each survey wave separately, the odds ratio for health-insurance coverage by highest educational level, relative to women with no education.

This is a descriptive population association. No causal interpretation is permitted.

### Reference analysis
Design-based logistic regression:
`survey::svyglm(insured ~ educ, design=full_design, family=quasibinomial())`

### M1 comparison
Ordinary unweighted logistic regression:
`glm(insured ~ educ, family=binomial())`

### M2 comparison
Weights-only survey logistic regression using the woman sampling weight but no PSU/stratum structure:
`survey::svyglm(insured ~ educ, design=weights_only_design, family=quasibinomial())`

### Metrics
For each education contrast:
- log odds ratio and odds ratio;
- standard error of the log odds ratio;
- 95% confidence interval;
- M1/reference and M2/reference log-OR difference;
- standard-error ratio;
- confidence-interval width ratio on the log scale;
- coefficient-sign change flag;
- descriptive flag for whether the 95% CI includes 1 under one method but excludes 1 under another.

The CI-crossing flag is descriptive only and is not a quality score or a significance-based method-selection rule.

## 9. Cross-survey replication

The full V1 and V2 analysis is run unchanged in RDHS 2019-20 and RDHS 2025.

The primary validation question is whether the *direction and magnitude of the inferential consequences of M1 and M2* recur in the new survey.

No formal test of equality between the two survey waves is planned.

No model will pool 2019-20 and 2025.

## 10. Why ANC is not the primary cross-survey validation outcome

ANC was considered because separate Paper 1 validation code already uses RDHS 2019-20 ANC data.

It is not selected for the Paper 2 out-of-sample validation because the published maternal-care reference universe changed: RDHS 2019-20 reports maternal-care indicators for the preceding five years, whereas RDHS 2025 uses the preceding two years and DHS-8 pregnancy-history structures. Health insurance, `v481`, provides a cleaner common IR-file outcome with the same target population and coding structure across both waves.

This decision was made before opening RDHS 2025 microdata.

## 11. Reporting

The manuscript will report:
- the two selected misalignments;
- the benchmark and out-of-sample surveys;
- all prespecified comparison analyses;
- V1 and V2 metrics;
- any failure of a known-answer or structural gate;
- whether the 2025 replication supports or weakens the 2019-20 consequence pattern.

The validation module is not used to revise literature classifications.

## 12. Reproducibility and restricted-data handling

Version controlled:
- this specification;
- analysis code;
- aggregate derived outputs;
- environment/session metadata;
- manuscript-ready tables/figures.

Not version controlled or redistributed:
- restricted RDHS microdata;
- authentication material;
- respondent-level extracts.

Authorised raw-file paths and raw-file hashes may be recorded in a protected local/Drive audit log.

## 13. Public metadata consulted before freeze

Public metadata only, not respondent-level microdata:
- NISR RDHS 2025 catalog, reference `rwa-nisr-rdhs7-2025-v01`;
- `RWIR91FL` public data dictionary;
- `v005`, `v021`, `v022`, `v106`, and `v481` metadata;
- published 2025 survey-design documentation reporting 560 clusters.

The public metadata check is not considered microdata access.

## 14. Freeze statement

This v1.0 specification is the pre-access gate required by the frozen Paper 2 protocol. RDHS 2025 respondent-level microdata must not be opened until this file and its corresponding analysis script are committed.
