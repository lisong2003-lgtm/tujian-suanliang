#!/usr/bin/env bash
# 梁自动结果与广联达模型汇总对照入口。
exec "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/run_cad.sh" cad_beam_benchmark "$@"
