# RDHS 2025 validation re-verification from authorised DHS Stata release

Date: 2026-10-13

## Purpose

Re-verify the already completed Paper 2 Rwanda validation using the exact authorised Rwanda DHS 2025 Stata release supplied locally by the corresponding author.

This check does not redefine the validation design. The controlling specification remains:

`RDHS_VALIDATION_SPEC_v1.0_FROZEN_2026-10-13.md`

which was frozen before RDHS 2025 respondent-level microdata access.

## Data handling

The DHS Program Stata ZIP and extracted respondent-level files remained on the authorised local Dell workstation and were not committed, uploaded, or redistributed.

The 2025 Individual Women Recode used for the check was extracted locally from the authorised DHS Program release.

The established 2019-20 benchmark file remained the previously authorised local RDHS 2019-20 Individual Women Recode cache.

## Execution

The frozen script `rdhs_validation_v1.0.R` was rerun unchanged with:

- authorised RDHS 2019-20 IR benchmark
- newly supplied RDHS 2025 `RWIR91FL.dta`
- a separate aggregate output directory so the earlier frozen outputs were not overwritten

The run completed with exit code 0.

All frozen structural and known-answer gates passed:

- RDHS 2019-20: 14,634 analysed women, 500 PSUs, 60 strata, minimum 2 PSUs per stratum
- RDHS 2025: 14,283 analysed women, 560 PSUs, 60 strata, minimum 2 PSUs per stratum
- RDHS 2019-20 full-design health-insurance estimate reproduced the 82.6% official benchmark within tolerance

## Reproducibility comparison

The newly generated aggregate files were compared with the previously frozen validation outputs.

The following files were byte-for-byte identical by SHA-256:

- `RDHS_validation_design_checks.csv`
- `RDHS_validation_V1_prevalence.csv`
- `RDHS_validation_V2_regression.csv`
- `RDHS_validation_sessionInfo.txt`

Therefore the validation results currently in `paper2/validation/generated/` are independently re-verified against the supplied DHS Program Stata release.

## Controlling interpretation

The out-of-sample 2025 validation supports a narrow inferential claim:

- omitting sampling weights can modestly shift population estimates and regression coefficients;
- ignoring PSU/stratum structure can substantially understate uncertainty even when weighted point estimates are unchanged;
- neither simplified analysis changed coefficient direction or whether the education contrasts' 95% confidence intervals included 1 in these two worked surveys.

The validation does not imply that every design simplification reverses substantive conclusions and does not revise any literature classification.
