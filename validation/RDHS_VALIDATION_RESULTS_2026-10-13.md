# Paper 2 Rwanda validation results

**Run date:** 2026-10-13  
**Frozen specification:** `RDHS_VALIDATION_SPEC_v1.0_FROZEN_2026-10-13.md`  
**Pre-access freeze merge:** `fa26de4d68444bd12b7d4c43f475ec3875ce4ecb`  
**Status:** PASS

## Restricted-data handling

The respondent-level Rwanda DHS files remain in the protected local DHS cache and are not committed to GitHub. The repository contains only the frozen specification/code, aggregate derived results, environment metadata, and manuscript-ready graphics.

## Design gates

| Survey | IR rows | PSUs | strata | minimum PSUs/stratum |
| --- | ---: | ---: | ---: | ---: |
| RDHS 2019-20 | 14,634 | 500 | 60 | 2 |
| RDHS 2025 | 14,283 | 560 | 60 | 2 |

The 2019-20 full-design estimate reproduced the official 82.6% health-insurance benchmark and weighted N=14,634 within the frozen tolerances.

## V1: national health-insurance prevalence

### RDHS 2019-20

- Full design: 82.647% (95% CI 81.541 to 83.700), SE 0.549 percentage points.
- Unweighted SRS: 83.224% (82.610 to 83.821), +0.577 percentage points versus the reference; SE ratio 0.562; variance ratio 0.316.
- Weights only: same weighted point estimate, 82.647% (81.975 to 83.299); SE ratio 0.615; variance ratio 0.378.

### RDHS 2025

- Full design: 87.430% (95% CI 86.536 to 88.273), SE 0.442 percentage points.
- Unweighted SRS: 87.895% (87.349 to 88.420), +0.465 percentage points versus the reference; SE ratio 0.618; variance ratio 0.382.
- Weights only: same weighted point estimate, 87.430% (86.834 to 88.003); SE ratio 0.675; variance ratio 0.455.

### V1 interpretation

The out-of-sample 2025 survey replicated the 2019-20 pattern. Omitting weights produced a modest upward point-estimate shift in both waves, while both simplified analyses substantially understated uncertainty. The full-design variance was approximately 3.16 times the unweighted-SRS variance and 2.65 times the weights-only variance in 2019-20; corresponding ratios in 2025 were approximately 2.62 and 2.20.

## V2: education and health-insurance association

Reference full-design odds ratios, relative to women with no education:

| Survey | Primary | Secondary | Higher |
| --- | --- | --- | --- |
| RDHS 2019-20 | 1.647 (1.429 to 1.898) | 3.009 (2.506 to 3.612) | 8.910 (5.393 to 14.721) |
| RDHS 2025 | 1.755 (1.455 to 2.118) | 3.760 (3.008 to 4.700) | 6.326 (3.630 to 11.023) |

In 2019-20, the unweighted SE ratios versus the full design were 0.926, 0.846 and 0.792 for primary, secondary and higher education; weights-only ratios were 0.980, 0.905 and 0.851.

In 2025, unweighted SE ratios were 0.869, 0.833 and 0.770; weights-only ratios were 0.918, 0.883 and 0.794.

The 2025 unweighted odds ratios were 1.854, 4.070 and 8.343, compared with full-design estimates of 1.755, 3.760 and 6.326. The largest relative coefficient shift was therefore in the higher-education contrast.

No method changed coefficient direction or whether a 95% confidence interval included 1 in either wave.

## Interpretation for the manuscript

The validation does **not** support a simplistic claim that design errors necessarily reverse substantive conclusions. It supports the narrower and more defensible claim that simplifying the DHS design can materially overstate precision and, depending on the contrast, alter point estimates or association magnitude. The same precision-distortion pattern replicated in a later independent Rwanda DHS wave.
