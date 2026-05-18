#!/usr/bin/env bash
set -euo pipefail

# Quarto on macOS writes cache and data under $HOME/Library/... .
# In sandboxed environments that path may be unwritable, so isolate HOME
# inside the repo for this command only.
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "${script_dir}/.." && pwd)"
workspace_home="${repo_root}/.quarto-home"

mkdir -p \
	"${workspace_home}/Library/Caches" \
	"${workspace_home}/Library/Application Support"

HOME="${workspace_home}" exec quarto "$@"
