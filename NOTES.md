# Notes for Compliance and Reviewers

This document supports the Q2 2026 Quarterly Scheme Return pipeline. It explains assumptions, open questions, data-quality choices, legacy reconciliation, and limitations.

The return is produced by `./run.sh`.

**For regulatory delivery**, use `output/q2_submission_2026Q2.csv` or DuckDB view `gold_q2_submission` (six SPEC categories, 12 rows).

The full audit pack is `output/q2_return_2026Q2.csv` / `gold_q2_return` (includes gross/refund split and `active_age_unknown`).

Lineage lives under `models/bronze`, `models/silver`, and `models/gold`.

---

# Implementation Notes

## Architecture
Local DuckDB + dbt using Bronze / Silver / Gold.

- Bronze reads the supplied CSV extracts with DuckDB `read_csv_auto()`.
- Silver normalizes identifiers/dates, applies business rules, reconciles Core vs Legacy CRM, and derives active members.
- Gold produces the six regulatory metrics and reconciliation summary.

---

## Source of truth
The Core platform is treated as authoritative for the regulatory return because the challenge states it is the system of record for pots and transactions. Legacy CRM is a reconciliation/control source; discrepancies are surfaced rather than silently overwriting Core.

---

## Business rules
- Q2: 2026-04-01 through 2026-06-30 inclusive.
- Active: Q2 contributor OR live pot.
- Live pot: ACTIVE and no leave date on/before quarter end.
- New joiner: join date in reporting period.
- Contributions: all Q2 amounts, including negative refunds.
- Transfers: IN/OUT completed in reporting period.
- Age: whole years at quarter end.
- Average pot: mean current pot value across active members.

---

## Data-quality
Blocking checks should cover duplicate transaction IDs, invalid required identifiers, invalid transaction directions, and conditions that make a regulatory metric unreliable. Reconciliation discrepancies and unknown-member transactions should be treated as investigation/warning controls unless Compliance defines them as blockers.

---

## Why DuckDB
This is a local analytical workload over CSV extracts. DuckDB reads them directly, avoiding unnecessary ingestion infrastructure.

## Why not dbt seeds
The supplied CSVs are operational extracts that can change by period, not small static reference data. Seeds are better for small version-controlled reference data.

---

## Gold datasets

- **`gold_q2_return`** — Full Q2 metric table (long format, one row per metric). Includes all six SPEC figures plus audit lines (gross/refund contributions, age band `UNKNOWN`). Exported to `output/q2_return_2026Q2.csv`.

- **`gold_q2_submission`** — Delivery subset: the six SPEC categories only (12 rows), with `spec_metric_number` and labels. Same values as the return table, without audit extras. Exported to `output/q2_submission_2026Q2.csv`.

- **`gold_reconciliation_summary`** — Single-row control totals: core vs legacy member counts, matches, unmatched on each side, and conflict counts (name, DOB, status). Not part of the regulatory return.

---

## AI usage disclosure

AI assistants Cursor was used to:

- Draft the medallion dbt project structure, SQL models, macros, and tests against the work-sample spec and TRD.
- Profile CSV anomalies and propose reconciliation and active-member interpretations.
- Help author this `NOTES.md` and technical documentation.

**Human review / corrections:** Business choices were confirmed explicitly (active member union including Q2 leavers; include orphan contributions with warnings). Pot pence assumption, date parsing, and core-as-system-of-record were validated against raw DuckDB queries on the CSVs. Any live interview change to SPEC should be implemented in Silver (`sl_active_members`, filters) rather than duplicated in Gold.

