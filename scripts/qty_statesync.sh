#!/usr/bin/env bash
# 土建 run_qty 接入 lis-skill-bus（薄壳，逻辑在 qty_statesync.py）。
# 用法：向 qty_statesync.py，见其 --help。
set -uo pipefail
HERE="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
PYTHON_BIN=""
for c in "${CODEX_PYTHON:-}" "$HOME"/.cache/codex-runtimes/codex-primary-runtime/dependencies/python/bin/python3 \
         "$HOME"/.cache/codex-runtimes/*/dependencies/python/bin/python3 "$(command -v python3 || true)"; do
  [[ -n "${c}" && -x "${c}" ]] && { PYTHON_BIN="${c}"; break; }
done
[[ -z "${PYTHON_BIN}" ]] && { echo "需要 Python 3.10+：设 CODEX_PYTHON 指向 python3" >&2; exit 1; }
exec "${PYTHON_BIN}" "$HERE/qty_statesync.py" "$@"
