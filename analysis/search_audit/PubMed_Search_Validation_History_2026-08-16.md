# PubMed precision-validation history

Date: 2026-08-16
Execution environment: GitHub Actions hosted Ubuntu runner, Python 3.12, NCBI E-utilities.

Purpose: retain the search-tuning audit trail before any production citation export.

## v0.3
Country/round-specific survey wording with several country acronyms and direct DHIS2 terms.

Result:
- grand union: **935**;
- assigned anchors recovered: **13/19**.

Disposition: rejected. PubMed phrase translation and acronym behavior caused both misses and noise.

## v0.4
Country + generic survey-family terminology, without round-year restriction; direct DHIS2 plus narrow routine-data rescues.

Result:
- survey union: **1,031**;
- DHIS2 union: **176**;
- grand union: **1,202**;
- assigned anchors: **19/19**.

Disposition: rejected for burden. Recall regression test passed but retrieval was unnecessarily broad.

## v0.5
Country + survey-family + eligible DHS round-year terms; MICS left broad because counts were small; DHIS2 retained direct terms plus DRC/Rwanda/Tanzania rescue searches.

Result:
- survey union: **571**;
- DHIS2 union: **176**;
- grand union: **744**;
- assigned anchors: **19/19**.

Disposition: passed the provisional <=750 guardrail but not frozen because Scopus would add records and the stated goal was the smallest scientifically defensible frame.

## DHS term-contribution diagnostic
For Rwanda, Kenya, Uganda, Burundi, Tanzania and DRC, the survey-family phrase, generic `DHS`, and country-specific acronyms were tested separately under the same country/round restrictions.

Key findings:
- Kenya: survey phrase alone recovered 2/2 anchors; `DHS` and `KDHS` recovered 0/2.
- Uganda: phrase alone recovered 1/1; `DHS` and `UDHS` recovered 0/1.
- Tanzania: phrase alone recovered 1/1; `DHS` also recovered it, while country acronyms recovered 0/1.
- Rwanda: phrase alone recovered 2/3 and `RDHS` recovered a complementary 2/3; their union recovers all 3.
- Burundi: phrase alone missed the assigned anchor; generic `DHS` recovered it.

This justified dropping non-contributing acronyms/terms rather than choosing synonyms by intuition.

## v0.6 candidate
Minimal empirical term set:
- Rwanda: survey phrase OR RDHS;
- Kenya: survey phrase only;
- Uganda: survey phrase only;
- Burundi: survey phrase OR DHS;
- Tanzania: survey phrase only;
- DRC: survey phrase OR DHS;
- MICS: country + MICS family;
- DHIS2: direct platform terms for all countries;
- routine-data rescue retained only for DRC and Tanzania because known eligible anchors require those paths;
- broad Rwanda HMIS/RHIS rescue dropped because no query-recall anchor justified the extra records; the source-unlabelled Rwanda hard case remains a supplementary-source pathway test.

Real NCBI result:
- survey union: **445**;
- DHIS2 union: **158**;
- grand union: **601**;
- assigned anchors: **19/19**.

Disposition: **promote as current PubMed production candidate**, subject to:
1. mandatory DHS Program supplementary journal-article discovery because survey-round year terms are used in PubMed;
2. Scopus/Publish or Perish translation and deduplication;
3. human-pilot completion before final protocol/search freeze.

## Interpretation
The tuning objective was not to minimize count at any cost. Each reduction had to preserve tested anchor recall and avoid outcome/disease restrictions. The final candidate reduces the PubMed frame from 1,202 to 601 while preserving 19/19 assigned anchors.

Anchor recall is conditional on the selected indexed regression-test set and is not presented as a numerical estimate of search sensitivity.
