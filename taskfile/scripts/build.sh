#!/usr/bin/env bash
# Example build script following rules.md: resolves a target, builds it,
# writes the result. Called from Taskfile.yml, which prints the summary.
#
# Usage: build.sh <target>
# Env:   OUT   output directory (default: ./out next to this script)
set -Eeuo pipefail

# Output convention: stage/info/note/ok/fail, color only on a TTY.
if [[ -t 1 && -z ${NO_COLOR:-} ]]; then
  _b=$'\e[1;34m' _w=$'\e[1;37m' _g=$'\e[1;32m' _r=$'\e[1;31m' _0=$'\e[0m'
else
  _b='' _w='' _g='' _r='' _0=''
fi
_failed='' _line=''
stage() { printf '\n%s▶ %s%s\n' "$_b" "$*" "$_0"; }
info()  { printf '  %s\n' "$*"; }
note()  { printf '  %s%s%s\n' "$_w" "$*" "$_0"; }
ok()    { printf '\n%s✓ %s%s\n' "$_g" "$*" "$_0"; }
fail()  { _failed=1; printf '\n%s✗ %s%s\n' "$_r" "$*" "$_0" >&2; }
die()   { fail "$*"; exit 1; }
trap '_line=$LINENO' ERR
_on_exit() { local rc=$?; [[ $rc -eq 0 || -n $_failed ]] || fail "Failed at line ${_line:-?} (exit $rc)"; }
trap _on_exit EXIT

HERE=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)
OUT=${OUT:-$HERE/../out}
target=${1:-}
[[ -n $target ]] || die "usage: build.sh <target>"

stage "[1/3] Resolve target"
info "target: $target"
info "output: $OUT"

stage "[2/3] Build"
mkdir -p "$OUT"
# Third-party build output goes here as is; this example only sleeps.
sleep 0.2

stage "[3/3] Write result"
printf '%s\n' "$target" > "$OUT/result"
note "Result written; run 'task verify' to check it again later"
# No ok "Done" here: the Taskfile defer prints the summary.
