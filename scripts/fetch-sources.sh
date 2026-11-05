#!/usr/bin/env bash
# sources/ に、README の「固定しているバージョン」と同じコミットのソースを取得する。
# 使い方: ./scripts/fetch-sources.sh（リポジトリのルートで実行）
set -euo pipefail

cd "$(dirname "$0")/.."
mkdir -p sources

# fetch <ディレクトリ名> <URL> <コミット> [sparse checkout するパス...]
fetch() {
  local name=$1 url=$2 commit=$3
  shift 3
  local dir="sources/$name"

  if [ -d "$dir" ]; then
    echo "skip: $dir はすでにある"
    return
  fi

  git init -q "$dir"
  git -C "$dir" remote add origin "$url"
  if [ $# -gt 0 ]; then
    # 必要なファイルだけを取り出す。blob は checkout するときに取得する
    git -C "$dir" sparse-checkout set --no-cone "$@"
    git -C "$dir" fetch -q --depth 1 --filter=blob:none origin "$commit"
  else
    git -C "$dir" fetch -q --depth 1 origin "$commit"
  fi
  git -C "$dir" checkout -q FETCH_HEAD
  echo "done: $dir ($(git -C "$dir" rev-parse --short HEAD))"
}

fetch uv https://github.com/astral-sh/uv.git \
  7d4cbc93fce3ccfa974d32de53c92258ef5f7782

fetch cpython https://github.com/python/cpython.git \
  25883627946b7cbcf7286acfe2a2019382375325 \
  /Lib/site.py /Lib/venv/ /Modules/getpath.py

fetch playwright-python https://github.com/microsoft/playwright-python.git \
  5306360397109b09704cf87ea611f3b74f79a368

fetch playwright https://github.com/microsoft/playwright.git \
  b4695e3eb2e6736d1a7b1fd255c4e94f78553660 \
  /packages/protocol/spec/ \
  /packages/utils/pipeTransport.ts \
  /packages/playwright-core/src/cli/ \
  /packages/playwright-core/src/server/dispatchers/ \
  /packages/playwright-core/src/server/chromium/ \
  /packages/playwright-core/src/server/pipeTransport.ts
