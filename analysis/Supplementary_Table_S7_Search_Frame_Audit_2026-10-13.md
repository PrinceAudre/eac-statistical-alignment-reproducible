# Supplementary Table S7. Search and candidate-frame audit

This table summarizes the reproducible search, deduplication, screening, eligibility, sampling, and DHIS2 robustness counts used in the manuscript. Search-query text, export hashes, anchor checks, and record-level adjudications remain in the version-controlled audit trail and are not reconstructed here.

| Stage | Source or step | Count | Notes |
|---|---|---:|---|
| Search | PubMed raw PMIDs | 603 | 18 frozen queries; one duplicate-index adjudication yielded 602 publication-level records |
| Search | PubMed publication-level records | 602 | Final production run 19 Aug 2026 |
| Search | Scopus raw exported records | 848 | 18 frozen RIS exports via Publish or Perish 8.19.5300.9483 |
| Search | Scopus unique publications | 793 | After exact-record deduplication |
| Deduplication | PubMed-Scopus overlap | 556 | Publication-level overlap |
| Deduplication | Primary bibliographic union | 839 | 602 + 793 - 556 |
| Supplementary discovery | DHS Program records identified | 159 | Prespecified supplementary source |
| Supplementary discovery | DHS Program records already in primary union | 68 | Overlap with PubMed/Scopus union |
| Supplementary discovery | DHS Program additional unique records | 91 | Added to primary union |
| Screening | Frozen candidate frame | 930 | 839 + 91 |
| Screening | Final title-abstract exclusions | 69 | Re-audit of 93 initially excluded records restored 24 to full-text review |
| Screening | Full-text frame | 861 | 930 - 69 |
| Full text | Full-text exclusions | 395 | Hierarchical first-applicable exclusion reason |
| Full text | Final eligible finite frame | 466 | 377 DHS/MICS and 89 DHIS2 |
| Eligibility evidence | Complete evidence at independent-review gate | 820 | Independently assessed by R1 and R2 |
| Eligibility evidence | Initially unresolved records | 41 | Resolved after sufficient evidence became available; no final pending records |
| Sampling | Detailed probability sample | 127 | 80 DHS/MICS and 47 DHIS2 |
| Reliability | Independent reliability subsample | 26 | 16 DHS/MICS and 10 DHIS2 |
| Robustness | Full DHIS2 census frame | 89 | Primary 47 plus 42 additional publications; post hoc robustness analysis |

## Audit interpretation

The 95% confidence intervals in the primary review quantify publication-subsampling uncertainty within the identified eligible finite frame. They do not quantify uncertainty from missed literature, eligibility misclassification, or future publications. Search-anchor checks were regression tests for known indexed records, not estimates of search sensitivity.


## Exact search companion audit

Exact PubMed and Scopus search strategies, search-validation history, production execution metadata, export hashes, cross-database deduplication, and the DHS Program supplementary-search audit are provided under `analysis/search_audit/`. The table above is the compact stage-count reconciliation used in the manuscript. Licensed raw database exports are not redistributed.

Final candidate-frame SHA-256: `6272c76e26244651b131dbac7770e32d7b290b3463f3d7f88bcb1710a6b9ef0f`.
