#!/bin/sh
set -eu

plenary_dir="${HOME}/.local/share/nvim/site/pack/vendor/start/plenary.nvim"

rm -rf "${plenary_dir}"

git clone \
    --depth 1 \
    https://github.com/nvim-lua/plenary.nvim \
    "${plenary_dir}"
