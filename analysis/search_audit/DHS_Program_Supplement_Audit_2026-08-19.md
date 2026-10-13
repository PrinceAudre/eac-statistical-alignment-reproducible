# DHS Program Journal Articles supplement audit - 2026-08-19

Status: complete. The prespecified 2020-2026 DHS Program supplementary search has been captured, internally deduplicated, reconciled against the 839-publication PubMed plus Scopus union, and incorporated into the immutable 930-record candidate frame.

## Search execution

The official DHS Program Journal Articles Search was run for Burundi, Congo Democratic Republic, Kenya, Rwanda, Tanzania, and Uganda with publication years 2020 through 2026. No topic, title, author, or journal restriction was applied.

- Burundi: https://www.dhsprogram.com/Publications/Journal-Articles-Search.cfm?Tl=&page=1&C_ID=89&T_ID=0&p_id=0&r_id=0&year1=2020&year2=2026&All=0&sort=2&subtopic=0&start_page=1
- Congo Democratic Republic: https://www.dhsprogram.com/Publications/Journal-Articles-Search.cfm?Tl=&page=1&C_ID=75&T_ID=0&p_id=0&r_id=0&year1=2020&year2=2026&All=0&sort=2&subtopic=0&start_page=1
- Kenya: https://www.dhsprogram.com/Publications/Journal-Articles-Search.cfm?Tl=&page=1&C_ID=11&T_ID=0&p_id=0&r_id=0&year1=2020&year2=2026&All=0&sort=2&subtopic=0&start_page=1
- Rwanda: https://www.dhsprogram.com/Publications/Journal-Articles-Search.cfm?Tl=&page=1&C_ID=54&T_ID=0&p_id=0&r_id=0&year1=2020&year2=2026&All=0&sort=2&subtopic=0&start_page=1
- Tanzania: https://www.dhsprogram.com/Publications/Journal-Articles-Search.cfm?Tl=&page=1&C_ID=18&T_ID=0&p_id=0&r_id=0&year1=2020&year2=2026&All=0&sort=2&subtopic=0&start_page=1
- Uganda: https://www.dhsprogram.com/Publications/Journal-Articles-Search.cfm?Tl=&page=1&C_ID=19&T_ID=0&p_id=0&r_id=0&year1=2020&year2=2026&All=0&sort=2&subtopic=0&start_page=1

## Capture and internal deduplication

- Country-result rows: **218**.
- Unique DHS Program article IDs: **162**.
- Publication-level records after collapsing three duplicate DHS entries: **159**.

Duplicate DHS entries were collapsed only on exact DOI plus exact title/year identity:

- 6271 / 6272, DOI `10.1186/s12884-025-07178-y`; canonical ID 6271.
- 5952 / 5957, DOI `10.1186/s12889-023-15620-z`; canonical ID 5952.
- 4970 / 5276, DOI `10.1093/heapol/czab079`; canonical ID 5276 because it contains the final volume/issue citation and stable article URL.

| Country filter | Result rows | Publication-level records | Already in primary 839 | New candidates |
|---|---:|---:|---:|---:|
| Burundi | 19 | 19 | 7 | 12 |
| Congo Democratic Republic | 14 | 14 | 0 | 14 |
| Kenya | 46 | 44 | 2 | 42 |
| Rwanda | 33 | 33 | 10 | 23 |
| Tanzania | 49 | 48 | 21 | 27 |
| Uganda | 57 | 57 | 34 | 23 |

Country columns are non-exclusive because multi-country publications appear under more than one filter.

## Reconciliation against the primary union

Matching followed the locked order: normalized exact DOI, then exact normalized title plus publication year only when DOI was unavailable. The full PubMed NBIB and all 18 Scopus RIS files were used in the final build.

- DHS Program publication-level records: **159**.
- Exact-DOI overlap with the primary PubMed plus Scopus union: **68**.
- Exact title/year fallback matches: **0**.
- Genuinely new supplementary candidates: **91**.
- Primary PubMed plus Scopus union: **839**.
- Final candidate-frame count: **930**.

`839 + 159 - 68 = 930`

Two source DOI problems were corrected before final matching:

- DHS ID 5797: the Figshare collection DOI was replaced with article DOI `10.1186/s12913-022-08169-x`.
- DHS ID 5350: the DHS-listed suffix `.654` was corrected to publisher/PubMed DOI `10.24248/eahrj.v5i1.653`.

All other missing or URL-embedded DOI resolutions remain documented in the publication audit CSV.

## Candidate-frame build

The deterministic builder generated 930 unique screen IDs and passed the DOI, title/year, source-count, pilot-resolution, and provenance checks.

- Candidate CSV: `SCREENING_FRAME_930_2026-08-19.csv`.
- SHA-256: `6272c76e26244651b131dbac7770e32d7b290b3463f3d7f88bcb1710a6b9ef0f`.
- Records with PubMed abstracts: 602.
- Title-only records from non-PubMed sources: 328.

The licensed/full candidate CSV is retained outside GitHub. GitHub records the reproducible builder, match audits, build audit, freeze note, and file hash.

## Screening consequence

Discovery and the candidate-frame build are closed at **930 publications**. Search retuning remains closed. ASReview may be used only to prioritize review order, and all 930 candidates require a human title/abstract decision. Main screening has not started.

Nineteen calibration records resolve within the frame. B03, PMID 35813509, is an external calibration-only boundary case and does not change the discovery count.

## Audit artifacts

- `production-output/DHS_PROGRAM_SUPPLEMENT_DISCOVERY_2026-08-19.csv`: 218 verified country-result rows.
- `production-output/DHS_PROGRAM_SUPPLEMENT_PUBLICATION_AUDIT_2026-08-19.csv`: 159 corrected publication-level DHS records.
- `production-output/DHS_PROGRAM_SUPPLEMENT_ADDITIONS_91_2026-08-19.csv`: 91 genuinely new candidates.
- `production-output/DHS_PROGRAM_SUPPLEMENT_DISCOVERY_SUMMARY_2026-08-19.txt`: machine-readable discovery count reconciliation.
- `../screening/production-output/DHS_PROGRAM_SUPPLEMENT_FINAL_MATCH_AUDIT_2026-08-19.csv`: final full-metadata match decisions.
- `../screening/production-output/SCREENING_FRAME_BUILD_AUDIT_2026-08-19.txt`: build validation.
- `../screening/production-output/SCREENING_FRAME_930_2026-08-19.sha256`: immutable candidate-file checksum.
- `../screening/CANDIDATE_FRAME_FREEZE_2026-08-19.md`: final freeze record.
