#!/usr/bin/env python3
"""
京东登录助手 - 使用 Playwright 直接控制 Chrome
解决 browser-use 的 watchdog 超时问题
"""
import asyncio
import json
import os
import sys
from pathlib import Path
from playwright.async_api import async_playwright, Browser, Page

# Chrome 用户数据目录（存放 cookies）
COOKIES_FILE = Path(__file__).parent / "jd_cookies.json"
USER_DATA_DIR = Path.home() / ".config" / "jd-chrome-profile"

async def save_cookies(context, filepath: Path):
    """保存 cookies 到文件"""
    cookies = await context.cookies()
    filepath.write_text(json.dumps(cookies, indent=2, ensure_ascii=False))
    print(f"✅ Cookies 已保存到: {filepath}")
    print(f"   共 {len(cookies)} 条 cookies")

async def load_cookies(filepath: Path) -> list:
    """从文件加载 cookies"""
    if filepath.exists():
        return json.loads(filepath.read_text())
    return []

async def login_jd():
    """登录京东并保存 cookies"""
    async with async_playwright() as p:
        # 启动 Chrome（ headed 模式）
        browser = await p.chromium.launch(
            headless=False,  # 有头模式，能看到窗口
            args=[
                '--no-sandbox',
                '--disable-dev-shm-usage',
                f'--user-data-dir={USER_DATA_DIR}',
            ]
        )

        context = await browser.new_context(
            viewport={'width': 1280, 'height': 900}
        )

        page = await context.new_page()

        print("🌐 打开京东登录页...")
        await page.goto('https://passport.jd.com/new/login.aspx?ReturnUrl=https%3A%2F%2Fwww.jd.com%2F')
        await page.wait_for_load_state('networkidle')

        print("⏳ 等待手动登录（请在浏览器窗口中扫码/输入账号密码）...")
        print("   登录成功后按回车继续...")
        input()

        # 保存 cookies
        await save_cookies(context, COOKIES_FILE)

        await browser.close()
        print("✅ 登录完成！")

async def auto_login_jd(username: str, password: str):
    """自动填表登录"""
    async with async_playwright() as p:
        browser = await p.chromium.launch(
            headless=False,
            args=['--no-sandbox', '--disable-dev-shm-usage']
        )

        context = await browser.new_context(
            viewport={'width': 1280, 'height': 900}
        )

        page = await context.new_page()
        await page.goto('https://passport.jd.com/new/login.aspx?ReturnUrl=https%3A%2F%2Fwww.jd.com%2F')
        await page.wait_for_load_state('domcontentloaded')

        # 填入账号密码
        await page.fill('#loginname', username)
        await page.fill('#nloginpwd', password)

        print("✅ 已填入账号密码")
        print("⏳ 请在浏览器中完成验证（滑动验证等）...")
        print("   完成后按回车继续...")
        input()

        await save_cookies(context, COOKIES_FILE)
        await browser.close()
        print("✅ 自动登录完成！")

async def use_jd_logged_in():
    """使用已保存的 cookies 登录京东"""
    cookies = await load_cookies(COOKIES_FILE)
    if not cookies:
        print("❌ 未找到 cookies，请先运行 login 命令")
        return

    async with async_playwright() as p:
        browser = await p.chromium.launch(
            headless=False,
            args=['--no-sandbox', '--disable-dev-shm-usage']
        )

        context = await browser.new_context(viewport={'width': 1280, 'height': 900})
        await context.add_cookies(cookies)

        page = await context.new_page()
        await page.goto('https://www.jd.com/')
        await page.wait_for_load_state('networkidle')

        title = await page.title()
        print(f"✅ 已登录！页面标题: {title}")

        # 等待保持浏览器打开
        print("浏览器将保持打开... 按 Ctrl+C 退出")
        await asyncio.Event().wait()

async def search_and_buy():
    """演示：登录后搜索产品"""
    cookies = await load_cookies(COOKIES_FILE)
    if not cookies:
        print("❌ 未找到 cookies，请先登录")
        return

    async with async_playwright() as p:
        browser = await p.chromium.launch(
            headless=False,
            args=['--no-sandbox', '--disable-dev-shm-usage']
        )

        context = await browser.new_context(viewport={'width': 1280, 'height': 900})
        await context.add_cookies(cookies)

        page = await context.new_page()
        await page.goto('https://www.jd.com/')
        await page.wait_for_load_state('networkidle')

        print(f"✅ 已登录京东: {await page.title()}")

        # 搜索
        await page.fill('#key', 'iPhone 15 Pro Max')
        await page.click('.button')
        await page.wait_for_load_state('networkidle')

        print(f"✅ 搜索结果: {await page.title()}")

        # 截图
        await page.screenshot(path='jd_search_results.png')
        print("📸 截图已保存: jd_search_results.png")

        await asyncio.sleep(2)

if __name__ == '__main__':
    cmd = sys.argv[1] if len(sys.argv) > 1 else 'help'

    if cmd == 'login':
        if len(sys.argv) > 3:
            asyncio.run(auto_login_jd(sys.argv[2], sys.argv[3]))
        else:
            asyncio.run(login_jd())
    elif cmd == 'use':
        asyncio.run(use_jd_logged_in())
    elif cmd == 'search':
        asyncio.run(search_and_buy())
    else:
        print("""
京东登录助手 - Playwright 版本

用法:
  python3 login_helper.py login              # 手动扫码登录
  python3 login_helper.py login <账号> <密码>  # 自动填表+手动验证
  python3 login_helper.py use              # 使用已保存的 cookies 登录
  python3 login_helper.py search           # 演示：登录后搜索产品

优势:
  - 直接用 Playwright 控制 Chrome，无 watchdog 超时问题
  - 支持 headed（有头）模式，能看到浏览器窗口
  - cookies 保存到本地，后续自动复用
  - 稳定可靠，不依赖 browser-use
""")
