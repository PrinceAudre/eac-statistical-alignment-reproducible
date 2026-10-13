# Search audit companion files

These files are release-safe copies of the frozen Paper 2 search audit trail used to construct the identified publication frame.

The PubMed v0.6 strategy file retains its original pre-freeze label because the audit record is not retrospectively rewritten. Anchor validation passed on 16 August 2026. The production manifest records execution on 19 August 2026 with 18 queries and 603 PMIDs before publication-level duplicate adjudication.

The Scopus / Publish or Perish run sheet preserves the exact search logic. The export-verification table records actual export IDs, raw counts, SHA-256 hashes, and anchor-check status for the 18 immutable RIS exports. Licensed Scopus exports are not redistributed.

The combined-frame audit documents PubMed-Scopus deduplication. The DHS Program supplement audit documents the prespecified supplementary discovery and construction of the 930-publication candidate frame.

Anchor checks were regression tests against known indexed records, not estimates of literature-search sensitivity.

Final candidate-frame SHA-256:
`6272c76e26244651b131dbac7770e32d7b290b3463f3d7f88bcb1710a6b9ef0f`
