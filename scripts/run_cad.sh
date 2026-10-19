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
BASE_VAL="$("$SKILL_DIR/scripts/ensure_base.sh")" || exit $?
if [ -z "$BASE_VAL" ]; then
  echo "[土建算量] 降级模式：未能获取识图底座 cad-file-reader；请提供已有扫描/测量 JSON 或设置 CAD_SKILL_DIR。" >&2
  exit 2
fi
CAD_SKILL_DIR="$BASE_VAL"
export CAD_SKILL_DIR
: "${CAD_MEM_LIMIT_MB:=4096}"; export CAD_MEM_LIMIT_MB
export PYTHONPATH="${SKILL_DIR}/scripts:${CAD_SKILL_DIR}/scripts:${CAD_SKILL_DIR}/vendor${PYTHONPATH:+:${PYTHONPATH}}"
SCRIPT_NAME="${1:?用法: run_cad.sh <脚本名> [参数...]}"; shift
exec "${PYTHON_BIN}" "${SKILL_DIR}/scripts/${SCRIPT_NAME}.py" "$@"
