#!/usr/bin/env bash
# 单层混凝土初算与缺口报告入口。
exec "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/run_cad.sh" cad_quantity "$@"
