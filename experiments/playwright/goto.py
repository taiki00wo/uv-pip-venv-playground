"""example.com を開いてタイトルを表示するだけのスクリプト。

--pause を付けると、ブラウザを閉じる前に Enter 待ちで止まる。
止まっている間に別のターミナルで ps を実行すると、プロセスの親子関係を観察できる。
"""

import sys

from playwright.sync_api import sync_playwright

with sync_playwright() as p:
    browser = p.chromium.launch()
    page = browser.new_page()
    page.goto("https://example.com")
    print(page.title())

    if "--pause" in sys.argv:
        input("Enter で終了します...")

    browser.close()
