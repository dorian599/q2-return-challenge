#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

if [ ! -d ".venv" ]; then
  python3 -m venv .venv
  source .venv/bin/activate
  pip install -q -r requirements.txt
else
  source .venv/bin/activate
fi

if [ ! -d "output" ]; then
  mkdir -p output
fi

dbt deps --profiles-dir .
dbt build --profiles-dir .

echo ""
echo "Full return:       output/q2_return_2026Q2.csv"
echo "Submission (SPEC): output/q2_submission_2026Q2.csv"
