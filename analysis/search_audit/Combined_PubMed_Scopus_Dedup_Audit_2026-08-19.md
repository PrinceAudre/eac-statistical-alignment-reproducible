# Combined PubMed–Scopus deduplication audit — 2026-08-19

Status: primary-source deduplication complete. Final candidate-frame freeze remains pending the prespecified DHS Program supplementary discovery step.

## Source frames
- Scopus after exact EID deduplication: **793 publications**.
- PubMed v0.6: **603 PMIDs**, representing **602 publications** after one duplicate-index adjudication.

## Cross-database matching
- Scopus records with DOI: 782; without DOI: 11.
- Shared unique DOI values: **556**.
- Shared publication-level records: **556**.
- PubMed PMIDs participating in those matches: 557 because one publication has two PMIDs.
- Exact normalized title + year fallback added **0** further matches.

## Bibliographic adjudication
PMIDs 35485093 and 35724092 share DOI `10.3917/spub.213.0445`, publication year 2021, journal *Sante Publique*, volume 33, issue 3, pages 445-458, and French language. They are duplicate index representations of one publication and are counted once. PMID 35724092 is the canonical PubMed identifier.

The same-title 2024 Scopus conference pair remains two distinct publications because the records have distinct EIDs and differ in first author/page range and IFIP volume.

## Primary-source union
Publication-level union before supplementary discovery:

`793 + 602 - 556 = 839`

Therefore the reproducible PubMed + Scopus checkpoint is **839 unique publications**.

Do not subtract the duplicate PubMed PMID again. It was already collapsed in the 602-publication PubMed count used in the set equation.

## Freeze status
**839 is not the final screening-frame N.** The DHS Program Journal Articles database is a prespecified supplementary discovery source for the DHS survey arm. Final freeze occurs only after that step is completed and any genuinely new records are deduplicated against this 839-publication union.

## Audit files
- `production-output/PUBMED_v0.6_DEDUP_KEYS.csv`
- `production-output/COMBINED_FRAME_DOI_MATCHES_2026-08-19.csv`
- `production-output/COMBINED_FRAME_NODOI_TITLE_MATCHES_2026-08-19.csv`
- `production-output/PUBMED_DUPLICATE_DOI_GROUPS_2026-08-19.csv`
- `production-output/PUBMED_DUPLICATE_DOI_RECORD_DETAILS_2026-08-19.csv`
- `production-output/BIBLIOGRAPHIC_ADJUDICATIONS_2026-08-19.csv`
- `production-output/COMBINED_FRAME_DOI_STAGE_SUMMARY_2026-08-19.txt`
