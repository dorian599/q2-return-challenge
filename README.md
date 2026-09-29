# Beehive Pensions — Data Engineering Work Sample

Thank you for taking part. Please read this file and `SPEC.md` in full before starting.

## The scenario

You have joined the data team at Beehive Pensions, a fictional UK pension provider. Every quarter, Beehive must submit a Quarterly Scheme Return to its regulator. The return is currently produced by hand from spreadsheet exports, and the deadline is fixed.

Build a small, repeatable pipeline that produces the return for **Q2 2026** from the source extracts in `data/`, with automated data-quality checks and written notes a compliance colleague could follow.

The data comes from two systems: the core platform (system of record for pots and transactions) and a legacy CRM that predates it. Like most real extracts, the data is not perfectly clean. Deciding what to do about that, and explaining your reasoning, is part of the task.

No knowledge of pensions or UK regulation is needed. Every business rule is in `SPEC.md`. Where the spec is unclear, make a reasonable decision, document it, and write down the question you would ask Compliance.

## Files

| File | Description |
| --- | --- |
| `data/members.csv` | Member records from the core platform |
| `data/contributions.csv` | Contribution transactions covering Q2 2026 and some records outside it |
| `data/transfers.csv` | Pension transfers in and out |
| `data/legacy_crm_members.csv` | Member export from the legacy CRM; overlaps with `members.csv` but was maintained separately |
| `SPEC.md` | The return specification |

## Deliverables

1. **A pipeline** producing the six metrics for Q2 2026 as a table or file. SQL, dbt, Python or any combination. Must run from a clean checkout with a single documented command and no manual steps.
2. **Automated data-quality checks** that run as part of the pipeline. Decide which problems stop the run (blocking) and which only warn, and explain your choices.
3. **A reconciliation** of `legacy_crm_members.csv` against `members.csv`: how many records match, are missing from one side, or conflict; which fields conflict; and your recommendation on which source the return should rely on, with reasons.
4. **`NOTES.md`** containing: assumptions and why; anything ambiguous in the spec with the question you would put to Compliance; data issues found and how you handled each; known limitations; a short AI-usage disclosure.

We are more interested in a smaller solution with clear reasoning than a complete one with none. If you run out of time, say so in `NOTES.md` and describe what you would do next.

## Time, tooling and AI

- **Time:** suggested maximum 4 hours. A guide, not a hard limit, but please don't spend significantly longer.
- **Tooling:** everything should run locally (DuckDB, SQLite or local Postgres; dbt and Python welcome). Do not require cloud accounts or credentials.
- **AI:** you may use AI assistants however you like. Disclose it in `NOTES.md` (which tools, for what, anything you rejected or corrected), and be ready to explain and modify every part of your solution live.

## Submitting

Clone this repository (do not fork it). Submit your solution as a separate private repository shared with the GitHub usernames provided by our recruiter, within one week. Include the command to run the pipeline in your `README.md`.

## What happens next

If your submission progresses, we will invite you to a 60-minute live session with two members of the data team. You will run your pipeline on your own machine and walk us through it, make a change to the business rules on the spot, run the pipeline against a new data file we provide, and discuss how you would operate this in production against a regulatory deadline.

Good luck, and thank you for your time.

---

## Solution: run the pipeline

From a clean checkout (requires Python 3):

```bash
chmod +x run.sh
./run.sh
```

This creates a virtualenv, installs `dbt-duckdb`, runs `dbt build`, and writes:

| Output | Description |
| --- | --- |
| `output/q2_submission_2026Q2.csv` | **Six SPEC metrics** (12 rows, delivery format) |
| `output/q2_return_2026Q2.csv` | Full return including gross/refund and age-unknown audit lines |
| `q2_return.duckdb` | Local DuckDB database with all dbt models |

See `NOTES.md` for assumptions, data-quality choices, and legacy reconciliation.

## Regulatory delivery output

The six metrics in `SPEC.md` are exposed as view **`gold_q2_submission`** (and CSV above). Query after `./run.sh`:

```bash
duckdb q2_return.duckdb -c "SELECT * FROM gold_q2_submission;"
```

Or in SQL:

```sql
SELECT * FROM gold_q2_submission;
```

For audit breakdowns (gross vs refund contributions, members with unknown age band), use `gold_q2_return` instead.
