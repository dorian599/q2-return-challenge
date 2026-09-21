# Quarterly Scheme Return — Specification

Provided by Beehive Pensions Compliance. Reporting period **1 April 2026 – 30 June 2026** inclusive. Quarter end **30 June 2026**. Extract date for all source files **1 July 2026**.

## Definitions

- **Active member:** a member who has made at least one contribution during the reporting period. Members with a live pot are considered active for the purposes of the return.
- **Live pot:** a member record with status `ACTIVE` and no leave date on or before quarter end.
- **New joiner:** a member whose join date falls within the reporting period.
- **Contribution:** a transaction in `contributions.csv`. Contributions are recorded in GBP.
- **Transfer in / transfer out:** a record in `transfers.csv` with direction `IN` or `OUT` respectively, completed within the reporting period.
- **Age:** the member's age in whole years at quarter end.

## Metrics to report

| # | Metric | Rule |
| --- | --- | --- |
| 1 | Active members at quarter end | Count of active members as at 30 June 2026 |
| 2 | New joiners | Count of new joiners in the reporting period |
| 3 | Total contributions received | Sum of contribution amounts in the reporting period, in GBP to two decimal places |
| 4 | Transfers in and transfers out | Count and total value of each, in the reporting period |
| 5 | Members by age band | Count of active members in each band: under 30, 30–49, 50–64, 65 and over |
| 6 | Average pot value | Mean current pot value across active members, in GBP to two decimal places |

## Notes from Compliance

- Refunds of contributions are recorded as negative amounts and should be netted off.
- Where a member appears in both the core platform and the legacy CRM, the return should reflect the correct position for that member.
- Figures must be reproducible: we may be asked to explain how any number was derived up to six years after submission.
