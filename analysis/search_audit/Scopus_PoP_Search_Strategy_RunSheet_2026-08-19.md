# Scopus / Publish or Perish run sheet — 2026-08-19

Status: execution sheet for the pre-freeze Scopus precision audit. Do not modify the scientific concepts during execution. Searches remain language-neutral. English full-text availability is assessed later at full-text eligibility.

## Before running
Record:
- Publish or Perish version;
- Scopus data source selected;
- date/time and time zone;
- any access/truncation warning.

For every query record the raw hit count before export. Inspect up to 25 records (all if fewer) and note whether at least 60% appear plausibly in-scope by title/abstract. Do not make final eligibility decisions during this precision audit.

Use native Scopus syntax if accepted by PoP. If PoP instead exposes separate fields, reproduce the same Boolean logic and save the exact populated fields.

## Designed-survey searches

### SCOPUS_SURVEY_RW_DHS
```text
TITLE-ABS-KEY(Rwanda AND ("Demographic and Health Survey" OR RDHS) AND (2019 OR 2020 OR "2019-20" OR "2019/20"))
AND PUBYEAR > 2019
AND DOCTYPE(ar)
```

### SCOPUS_SURVEY_KE_DHS
```text
TITLE-ABS-KEY(Kenya AND "Demographic and Health Survey" AND 2022)
AND PUBYEAR > 2019
AND DOCTYPE(ar)
```

### SCOPUS_SURVEY_UG_DHS
```text
TITLE-ABS-KEY(Uganda AND "Demographic and Health Survey" AND 2016)
AND PUBYEAR > 2019
AND DOCTYPE(ar)
```

### SCOPUS_SURVEY_BI_DHS
```text
TITLE-ABS-KEY(Burundi AND ("Demographic and Health Survey" OR DHS) AND (2016 OR 2017 OR "2016-17" OR "2016/17"))
AND PUBYEAR > 2019
AND DOCTYPE(ar)
```

### SCOPUS_SURVEY_TZ_DHS
```text
TITLE-ABS-KEY((Tanzania OR "United Republic of Tanzania") AND "Demographic and Health Survey" AND (2015 OR 2016 OR 2022 OR "2015-16" OR "2015/16"))
AND PUBYEAR > 2019
AND DOCTYPE(ar)
```

### SCOPUS_SURVEY_CD_DHS
```text
TITLE-ABS-KEY(("Democratic Republic of the Congo" OR "Congo Democratic Republic" OR "DR Congo" OR DRC OR RDC) AND ("Demographic and Health Survey" OR DHS) AND (2023 OR 2024 OR "2023-24" OR "2023/24"))
AND PUBYEAR > 2019
AND DOCTYPE(ar)
```

### SCOPUS_MICS_CD
```text
TITLE-ABS-KEY(("Democratic Republic of the Congo" OR "Congo Democratic Republic" OR "DR Congo" OR DRC OR RDC) AND ("Multiple Indicator Cluster Survey" OR "Multiple Indicator Cluster Surveys" OR MICS))
AND PUBYEAR > 2019
AND DOCTYPE(ar)
```

### SCOPUS_MICS_SS
```text
TITLE-ABS-KEY("South Sudan" AND ("Multiple Indicator Cluster Survey" OR "Multiple Indicator Cluster Surveys" OR MICS))
AND PUBYEAR > 2019
AND DOCTYPE(ar)
```

## DHIS2 core searches

Use this platform block in each query:
```text
(DHIS2 OR "DHIS 2" OR "DHIS-2" OR "District Health Information System 2" OR "District Health Information Software 2" OR "District Health Information System version 2" OR "District Health Information Software version 2")
```

### SCOPUS_DHIS2_BI
```text
TITLE-ABS-KEY((DHIS2 OR "DHIS 2" OR "DHIS-2" OR "District Health Information System 2" OR "District Health Information Software 2" OR "District Health Information System version 2" OR "District Health Information Software version 2") AND Burundi)
AND PUBYEAR > 2019
AND DOCTYPE(ar)
```

### SCOPUS_DHIS2_CD
```text
TITLE-ABS-KEY((DHIS2 OR "DHIS 2" OR "DHIS-2" OR "District Health Information System 2" OR "District Health Information Software 2" OR "District Health Information System version 2" OR "District Health Information Software version 2") AND ("Democratic Republic of the Congo" OR "Congo Democratic Republic" OR "DR Congo" OR DRC OR RDC))
AND PUBYEAR > 2019
AND DOCTYPE(ar)
```

### SCOPUS_DHIS2_KE
```text
TITLE-ABS-KEY((DHIS2 OR "DHIS 2" OR "DHIS-2" OR "District Health Information System 2" OR "District Health Information Software 2" OR "District Health Information System version 2" OR "District Health Information Software version 2") AND Kenya)
AND PUBYEAR > 2019
AND DOCTYPE(ar)
```

### SCOPUS_DHIS2_RW
```text
TITLE-ABS-KEY((DHIS2 OR "DHIS 2" OR "DHIS-2" OR "District Health Information System 2" OR "District Health Information Software 2" OR "District Health Information System version 2" OR "District Health Information Software version 2") AND Rwanda)
AND PUBYEAR > 2019
AND DOCTYPE(ar)
```

### SCOPUS_DHIS2_SO
```text
TITLE-ABS-KEY((DHIS2 OR "DHIS 2" OR "DHIS-2" OR "District Health Information System 2" OR "District Health Information Software 2" OR "District Health Information System version 2" OR "District Health Information Software version 2") AND Somalia)
AND PUBYEAR > 2019
AND DOCTYPE(ar)
```

### SCOPUS_DHIS2_SS
```text
TITLE-ABS-KEY((DHIS2 OR "DHIS 2" OR "DHIS-2" OR "District Health Information System 2" OR "District Health Information Software 2" OR "District Health Information System version 2" OR "District Health Information Software version 2") AND "South Sudan")
AND PUBYEAR > 2019
AND DOCTYPE(ar)
```

### SCOPUS_DHIS2_TZ
```text
TITLE-ABS-KEY((DHIS2 OR "DHIS 2" OR "DHIS-2" OR "District Health Information System 2" OR "District Health Information Software 2" OR "District Health Information System version 2" OR "District Health Information Software version 2") AND (Tanzania OR "United Republic of Tanzania"))
AND PUBYEAR > 2019
AND DOCTYPE(ar)
```

### SCOPUS_DHIS2_UG
```text
TITLE-ABS-KEY((DHIS2 OR "DHIS 2" OR "DHIS-2" OR "District Health Information System 2" OR "District Health Information Software 2" OR "District Health Information System version 2" OR "District Health Information Software version 2") AND Uganda)
AND PUBYEAR > 2019
AND DOCTYPE(ar)
```

## Evidence-justified routine-data rescues

Run only these two rescue searches.

### SCOPUS_RHIS_RESCUE_CD
```text
TITLE-ABS-KEY(("health management information system" OR HMIS OR "routine health information system" OR RHIS OR "national health information system" OR "routine health data" OR "routine health facility data" OR "routine surveillance data")
AND ("Democratic Republic of the Congo" OR "Congo Democratic Republic" OR "DR Congo" OR DRC OR RDC)
AND (analys* OR trend* OR "time series" OR coverage OR incidence OR rate* OR count* OR association* OR evaluation OR forecast* OR completeness OR timeliness OR surveillance))
AND PUBYEAR > 2019
AND DOCTYPE(ar)
```

### SCOPUS_RHIS_RESCUE_TZ
```text
TITLE-ABS-KEY(("health management information system" OR HMIS OR "routine health information system" OR RHIS OR "national health information system" OR "routine health data" OR "routine health facility data" OR "routine surveillance data")
AND (Tanzania OR "United Republic of Tanzania")
AND (analys* OR trend* OR "time series" OR coverage OR incidence OR rate* OR count* OR association* OR evaluation OR forecast* OR completeness OR timeliness OR surveillance))
AND PUBYEAR > 2019
AND DOCTYPE(ar)
```

## Results table to complete

| Search ID | Raw hits | Inspected n | Plausibly in scope n | Plausibility % | Anchor status | Truncation? | Dominant noise / note |
|---|---:|---:|---:|---:|---|---|---|
| SCOPUS_SURVEY_RW_DHS |  |  |  |  |  |  |  |
| SCOPUS_SURVEY_KE_DHS |  |  |  |  |  |  |  |
| SCOPUS_SURVEY_UG_DHS |  |  |  |  |  |  |  |
| SCOPUS_SURVEY_BI_DHS |  |  |  |  |  |  |  |
| SCOPUS_SURVEY_TZ_DHS |  |  |  |  |  |  |  |
| SCOPUS_SURVEY_CD_DHS |  |  |  |  |  |  |  |
| SCOPUS_MICS_CD |  |  |  |  |  |  |  |
| SCOPUS_MICS_SS |  |  |  |  |  |  |  |
| SCOPUS_DHIS2_BI |  |  |  |  |  |  |  |
| SCOPUS_DHIS2_CD |  |  |  |  |  |  |  |
| SCOPUS_DHIS2_KE |  |  |  |  |  |  |  |
| SCOPUS_DHIS2_RW |  |  |  |  |  |  |  |
| SCOPUS_DHIS2_SO |  |  |  |  |  |  |  |
| SCOPUS_DHIS2_SS |  |  |  |  |  |  |  |
| SCOPUS_DHIS2_TZ |  |  |  |  |  |  |  |
| SCOPUS_DHIS2_UG |  |  |  |  |  |  |  |
| SCOPUS_RHIS_RESCUE_CD |  |  |  |  |  |  |  |
| SCOPUS_RHIS_RESCUE_TZ |  |  |  |  |  |  |  |

## Export rule
Do not export a query until its raw count and precision audit are recorded. After the audit passes, export the richest available RIS and/or CSV, keep each query export separate and immutable, calculate SHA-256, and back it up to Drive `Paper 2 Back-up/01_Search_Exports`.

After combining with PubMed, deduplicate before assessing burden. Desired combined unique frame <=800; >1,000 triggers refinement before screening freeze.
