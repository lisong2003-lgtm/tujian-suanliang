#!/usr/bin/env bash
# 统一入口：解释器三级回退 + 底座定位 + 内存闸
set -euo pipefail
SKILL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PYTHON_BIN=""
for c in "${CODEX_PYTHON:-}" "$HOME"/.cache/codex-runtimes/codex-primary-runtime/dependencies/python/bin/python3 \
         "$HOME"/.cache/codex-runtimes/*/dependencies/python/bin/python3 "$(command -v python3 || true)"; do
  [[ -n "${c}" && -x "${c}" ]] && { PYTHON_BIN="${c}"; break; }
done
[[ -z "${PYTHON_BIN}" ]] && { echo "需要 Python 3.10+：设 CODEX_PYTHON 指向 python3" >&2; exit 1; }
: "${CAD_MEM_LIMIT_MB:=4096}"; export CAD_MEM_LIMIT_MB
if [[ -z "${CAD_SKILL_DIR:-}" ]]; then
  for d in "$HOME/.codex/skills/cad-file-reader" "$HOME/.claude/skills/cad-file-reader"; do
    [[ -d "$d" ]] && { CAD_SKILL_DIR="$d"; break; }
  done
fi
[[ -z "${CAD_SKILL_DIR:-}" ]] && { echo "找不到底座技能 cad-file-reader：设 CAD_SKILL_DIR 指向它" >&2; exit 2; }
export CAD_SKILL_DIR
export PYTHONPATH="${SKILL_DIR}/scripts:${CAD_SKILL_DIR}/scripts:${CAD_SKILL_DIR}/vendor${PYTHONPATH:+:${PYTHONPATH}}"
if [[ "${1:-}" == "advanced" || "${1:-}" == "pipeline" ]]; then
  shift
  exec "${PYTHON_BIN}" "${SKILL_DIR}/scripts/cad_quantity_pipeline.py" "$@"
fi
exec "${PYTHON_BIN}" "${SKILL_DIR}/scripts/qty_core.py" "$@"
