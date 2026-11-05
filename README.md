# uv-pip-venv-playground

uv が pip と venv の役割をどう担っているのか、venv がなぜプロジェクト単位で効くのかを、ソースコードと実験で確かめるための作業場所。

## 手元で再現する

`sources/` と比較用の venv はリポジトリに含めていない。次のコマンドで作る。

```bash
./scripts/fetch-sources.sh
```

```bash
python3 -m venv std-venv
```

```bash
uv venv uv-venv
```

`fetch-sources.sh` は、下の「固定しているバージョン」のコミットを取得する。CPython と microsoft/playwright は、必要なファイルだけを sparse checkout する。

## ディレクトリ構成

```
uv-pip-venv-playground/
├── README.md        # このファイル
├── NOTES.md         # 記事のテーマ案
├── scripts/
│   └── fetch-sources.sh  # sources/ を固定コミットで取得する
├── std-venv/        # python3 -m venv で作った venv（activate の比較用、Git 管理外）
├── uv-venv/         # uv venv で作った venv（activate の比較用、Git 管理外）
├── experiments/     # 実験用の venv やプロジェクトを作る場所
│   ├── lockfile/    # uv.lock と uv run の実験用 uv プロジェクト
│   └── playwright/  # Playwright の実験用 uv プロジェクト（goto.py）
└── sources/         # 読むソースコード（Git 管理外）
    ├── uv/                  # astral-sh/uv（shallow clone）
    ├── cpython/             # python/cpython（venv 関連ファイルだけの sparse checkout）
    ├── playwright-python/   # microsoft/playwright-python（shallow clone）
    └── playwright/          # microsoft/playwright（通信まわりだけの sparse checkout）
```

## 固定しているバージョン

記事に行番号を書くときは、このコミットを基準にする。

| リポジトリ | コミット | 日時 |
|---|---|---|
| astral-sh/uv | `7d4cbc9` | 2026-10-14 |
| python/cpython | `2588362` | 2026-10-14 |
| microsoft/playwright-python | `5306360` | 2026-10-26 |
| microsoft/playwright | `b4695e3` | 2026-10-23 |

microsoft/playwright のコミットは、playwright-python の `DRIVER_VERSION` に書かれているもの。

手元の `uv` コマンドは 0.9.14 で、ソースより古い。挙動を説明するときはバージョン差に注意する。

## CPython で取得しているファイル

- `Lib/site.py`
- `Lib/venv/`
- `Modules/getpath.py`

ほかのファイルが必要になったら、`sources/cpython` で次のように追加する。追加したパスは `scripts/fetch-sources.sh` にも書き足す。

```bash
git sparse-checkout add /Lib/sysconfig/
```

## microsoft/playwright で取得しているファイル

- `packages/protocol/spec/`
- `packages/utils/pipeTransport.ts`
- `packages/playwright-core/src/cli/`
- `packages/playwright-core/src/server/dispatchers/`
- `packages/playwright-core/src/server/chromium/`
- `packages/playwright-core/src/server/pipeTransport.ts`

追加の方法は CPython と同じ（`sources/playwright` で `git sparse-checkout add`）。
