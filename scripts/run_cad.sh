#!/usr/bin/env bash
# 土建算量内部脚本入口：优先本技能脚本，底座仅提供识图模块与 vendor。
set -euo pipefail
SKILL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PYTHON_BIN=""
for candidate in "${CODEX_PYTHON:-}" "$HOME"/.cache/codex-runtimes/codex-primary-runtime/dependencies/python/bin/python3 \
  "$HOME"/.cache/codex-runtimes/*/dependencies/python/bin/python3 "$(command -v python3 || true)"; do
  if [[ -n "${candidate}" && -x "${candidate}" ]]; then
    PYTHON_BIN="${candidate}"
    break
  fi
done
[[ -z "${PYTHON_BIN}" ]] && { echo "需要 Python 3.10+：设 CODEX_PYTHON 指向 python3" >&2; exit 1; }
if [[ -z "${CAD_SKILL_DIR:-}" ]]; then
  for d in "$HOME/.codex/skills/cad-file-reader" "$HOME/.claude/skills/cad-file-reader"; do
    [[ -d "$d" ]] && { CAD_SKILL_DIR="$d"; break; }
  done
fi
[[ -z "${CAD_SKILL_DIR:-}" ]] && { echo "找不到底座技能 cad-file-reader：设 CAD_SKILL_DIR 指向它" >&2; exit 2; }
export CAD_SKILL_DIR
: "${CAD_MEM_LIMIT_MB:=4096}"; export CAD_MEM_LIMIT_MB
export PYTHONPATH="${SKILL_DIR}/scripts:${CAD_SKILL_DIR}/scripts:${CAD_SKILL_DIR}/vendor${PYTHONPATH:+:${PYTHONPATH}}"
SCRIPT_NAME="${1:?用法: run_cad.sh <脚本名> [参数...]}"; shift
exec "${PYTHON_BIN}" "${SKILL_DIR}/scripts/${SCRIPT_NAME}.py" "$@"
