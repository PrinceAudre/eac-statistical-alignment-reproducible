# Precision-first search strings v0.6 candidate

Status: **PubMed burden/anchor validation passed on 2026-08-16.** Do not call final/frozen until the human pilot and Scopus/Publish or Perish translation checks are complete.

This file supersedes earlier precision candidates for production-search planning. Earlier files remain as an audit trail.

## Design principle
The production bibliographic search is deliberately narrow enough to keep the screening frame manageable while preserving tested recall.

Core restrictions are based on:
- data source/family;
- EAC country;
- contemporary publication window;
- eligible survey round for DHS;
- exact DHIS2 terminology plus only evidence-justified country-specific routine-data rescues.

No disease/outcome restriction is used.

Because DHS survey-round year terms are used in PubMed to control burden, the **DHS Program peer-reviewed journal-article database is a mandatory supplementary discovery source**, not optional reassurance. It is used to recover eligible DHS analyses whose bibliographic title/abstract omits the survey-round year or uses atypical terminology.

Publication window: 2020-01-01 through final search date.

## PubMed designed-survey queries

### Rwanda, RDHS 2019-20
```text
Rwanda[tiab]
AND ("Demographic and Health Survey"[tiab] OR RDHS[tiab])
AND (2019[tiab] OR 2020[tiab] OR "2019-20"[tiab] OR "2019/20"[tiab])
AND 2020:3000[dp]
```
Validation count 2026-08-16: **75**. Assigned anchors: 3/3.

### Kenya, KDHS 2022
```text
Kenya[tiab]
AND "Demographic and Health Survey"[tiab]
AND 2022[tiab]
AND 2020:3000[dp]
```
Validation count: **75**. Assigned anchors: 2/2.

### Uganda, UDHS 2016
```text
Uganda[tiab]
AND "Demographic and Health Survey"[tiab]
AND 2016[tiab]
AND 2020:3000[dp]
```
Validation count: **91**. Assigned anchors: 1/1.

### Burundi, DHS 2016-17
```text
Burundi[tiab]
AND ("Demographic and Health Survey"[tiab] OR DHS[tiab])
AND (2016[tiab] OR 2017[tiab] OR "2016-17"[tiab] OR "2016/17"[tiab])
AND 2020:3000[dp]
```
Validation count: **32**. Assigned anchors: 1/1.

### Tanzania, DHS/MIS 2015-16 and 2022
```text
(Tanzania[tiab] OR "United Republic of Tanzania"[tiab])
AND "Demographic and Health Survey"[tiab]
AND (2015[tiab] OR 2016[tiab] OR 2022[tiab] OR "2015-16"[tiab] OR "2015/16"[tiab])
AND 2020:3000[dp]
```
Validation count: **160**. Assigned anchors: 1/1.

### Democratic Republic of the Congo, DHS 2023-24
```text
("Democratic Republic of the Congo"[tiab]
 OR "Congo Democratic Republic"[tiab]
 OR "DR Congo"[tiab]
 OR DRC[tiab]
 OR RDC[tiab])
AND ("Demographic and Health Survey"[tiab] OR DHS[tiab])
AND (2023[tiab] OR 2024[tiab] OR "2023-24"[tiab] OR "2023/24"[tiab])
AND 2020:3000[dp]
```
Validation count: **10**. No eligible PubMed anchor currently available, so recall for this arm remains explicitly unvalidated.

## PubMed MICS queries

### DRC MICS
```text
("Democratic Republic of the Congo"[tiab]
 OR "Congo Democratic Republic"[tiab]
 OR "DR Congo"[tiab]
 OR DRC[tiab]
 OR RDC[tiab])
AND ("Multiple Indicator Cluster Survey"[tiab]
     OR "Multiple Indicator Cluster Surveys"[tiab]
     OR MICS[tiab])
AND 2020:3000[dp]
```
Validation count: **14**. Assigned anchors: 1/1.

### South Sudan MICS
```text
"South Sudan"[tiab]
AND ("Multiple Indicator Cluster Survey"[tiab]
     OR "Multiple Indicator Cluster Surveys"[tiab]
     OR MICS[tiab])
AND 2020:3000[dp]
```
Validation count: **2**. Recall remains unvalidated because no eligible indexed anchor is currently assigned.

## PubMed DHIS2 core block
```text
(DHIS2[tiab]
 OR "DHIS 2"[tiab]
 OR "DHIS-2"[tiab]
 OR "District Health Information System 2"[tiab]
 OR "District Health Information Software 2"[tiab]
 OR "District Health Information System version 2"[tiab]
 OR "District Health Information Software version 2"[tiab])
```

Run separately with each EAC country clause and `2020:3000[dp]`.

Validation core counts:
- Burundi: **0**
- DRC: **7**
- Kenya: **27**
- Rwanda: **10**
- Somalia: **5**
- South Sudan: **3**
- Tanzania: **17**
- Uganda: **48**

## Evidence-justified routine-data rescues
Broad EAC-wide HMIS/RHIS searching is prohibited.

Only two country-specific rescues are currently retained because each is required to recover a known eligible DHIS2-provenance anchor missed by the direct DHIS2 core wording.

### DRC routine-data rescue
```text
("health management information system"[tiab]
 OR HMIS[tiab]
 OR "routine health information system"[tiab]
 OR RHIS[tiab]
 OR "national health information system"[tiab]
 OR "routine health data"[tiab]
 OR "routine health facility data"[tiab]
 OR "routine surveillance data"[tiab])
AND
("Democratic Republic of the Congo"[tiab]
 OR "Congo Democratic Republic"[tiab]
 OR "DR Congo"[tiab]
 OR DRC[tiab]
 OR RDC[tiab])
AND
(analys*[tiab] OR trend*[tiab] OR "time series"[tiab]
 OR coverage[tiab] OR incidence[tiab] OR rate*[tiab] OR count*[tiab]
 OR association*[tiab] OR evaluation[tiab] OR forecast*[tiab]
 OR completeness[tiab] OR timeliness[tiab] OR surveillance[tiab])
AND 2020:3000[dp]
```
Validation count: **16**. Combined DRC DHIS2 arm: **21** unique records, assigned anchors 2/2.

### Tanzania routine-data rescue
Use the same routine and quantitative blocks with:
```text
(Tanzania[tiab] OR "United Republic of Tanzania"[tiab])
```
Validation count: **33**. Combined Tanzania DHIS2 arm: **46** unique records, assigned anchors 4/4.

### Rwanda rescue decision
A broad Rwanda HMIS/RHIS rescue was tested but **not retained** in v0.6 because no query-recall anchor justified its additional 19 unique records. The known Rwanda source-unlabelled hard case (PMID 35899240) is instead a test of the prespecified supplementary-source/citation pathway.

## PubMed v0.6 validation result
Real NCBI E-utilities run on GitHub Actions, 2026-08-16:

- designed-survey union: **445** unique records, assigned anchors 9/9;
- DHIS2 union: **158** unique records, assigned anchors 10/10;
- PubMed grand union: **601** unique records, assigned anchors **19/19**.

The overlap between worlds explains why 445 + 158 is slightly greater than 601.

### Gate result
- tested anchor recall: **PASS**;
- burden gate <=650 PubMed records: **PASS**;
- broad-data-dump criterion: **PASS**;
- unvalidated country arms remain explicitly labelled as such and are supported by supplementary discovery where applicable.

Anchor recall is a regression test conditional on indexing/terminology. It is not claimed as an estimate of complete literature-search sensitivity.

## Scopus / Publish or Perish translation
Translate **the same minimal logic**, not the earlier broad query.

For DHS, use country + survey-family phrase + eligible round-year terms in `TITLE-ABS-KEY`, publication year >=2020, document type article.

For example, Kenya:
```text
TITLE-ABS-KEY(Kenya AND "Demographic and Health Survey" AND 2022)
AND PUBYEAR > 2019
AND DOCTYPE(ar)
```

For DHIS2, use the exact platform block + one country at a time. Run only the DRC and Tanzania routine-data rescue blocks unless Scopus validation identifies a specific additional missed eligible anchor.

The Scopus/PoP result set is deduplicated against the PubMed frame before any decision to broaden or tighten. A large raw Scopus count is not automatically accepted.

## Freeze rule
Do not modify these production concepts after final search freeze unless a dated protocol amendment documents:
1. the problem discovered;
2. whether outcomes had been seen;
3. the exact search change;
4. the incremental records added/removed;
5. any sensitivity implication.
