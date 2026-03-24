#!/usr/bin/env python3
"""
茶叶网站图片采集器 - 用 Playwright 真实登录京东抓图
"""
import asyncio
import json
import os
from pathlib import Path
from playwright.async_api import async_playwright

COOKIES_FILE = Path(__file__).parent / "jd_cookies.json"
IMAGES_DIR = Path(__file__).parent / "images"
IMAGES_DIR.mkdir(exist_ok=True)

async def save_cookies(context):
    cookies = await context.cookies()
    COOKIES_FILE.write_text(json.dumps(cookies, indent=2))
    print(f"✅ Cookies 保存到: {COOKIES_FILE}")

async def load_cookies():
    if COOKIES_FILE.exists():
        return json.loads(COOKIES_FILE.read_text())
    return []

async def login_and_save():
    """登录京东并保存cookies"""
    async with async_playwright() as p:
        browser = await p.chromium.launch(headless=False, args=['--no-sandbox'])
        context = await browser.new_context(viewport={'width': 1280, 'height': 900})
        page = await context.new_page()
        
        await page.goto('https://passport.jd.com/new/login.aspx')
        print("⏳ 请登录京东（扫码或账号密码）...")
        print("登录成功后按回车继续...")
        input()
        
        await save_cookies(context)
        await browser.close()
        print("✅ 登录完成！")

async def fetch_product_images():
    """用已保存的cookies抓取产品图片"""
    cookies = await load_cookies()
    if not cookies:
        print("❌ 未登录，请先运行: python3 fetch_images.py login")
        return
    
    async with async_playwright() as p:
        browser = await p.chromium.launch(headless=False, args=['--no-sandbox'])
        context = await browser.new_context(viewport={'width': 1280, 'height': 900})
        await context.add_cookies(cookies)
        
        # 搜索的茶叶产品
        products = [
            ('西湖龙井', '龙井'),
            ('武夷山大红袍', '大红袍'),
            ('云南普洱', '普洱'),
            ('安溪铁观音', '铁观音'),
            ('福鼎白茶', '白茶'),
            ('碧螺春', '碧螺春'),
        ]
        
        for keyword, filename in products:
            print(f"\n🔍 搜索: {keyword}")
            page = await context.new_page()
            await page.goto(f'https://search.jd.com/Search?keyword={keyword}+茶叶&enc=utf-8')
            await page.wait_for_load_state('networkidle', timeout=10000)
            
            # 获取第一个商品的主图
            img = await page.query_selector('.gl-item img, .p-img img, .goods-item img')
            if img:
                src = await img.get_attribute('src') or await img.get_attribute('data-src')
                print(f"  图片: {src[:80] if src else '无'}...")
                if src and not src.startswith('data:'):
                    import urllib.request
                    img_path = IMAGES_DIR / f"{filename}.jpg"
                    try:
                        if src.startswith('//'):
                            src = 'https:' + src
                        urllib.request.urlretrieve(src, img_path)
                        print(f"  ✅ 保存: {img_path}")
                    except Exception as e:
                        print(f"  ❌ 下载失败: {e}")
            else:
                print(f"  ❌ 未找到图片元素")
            
            await page.close()
        
        await browser.close()

if __name__ == '__main__':
    import sys
    cmd = sys.argv[1] if len(sys.argv) > 1 else 'help'
    
    if cmd == 'login':
        asyncio.run(login_and_save())
    elif cmd == 'fetch':
        asyncio.run(fetch_product_images())
    else:
        print("""
茶叶图片采集器

用法:
  python3 fetch_images.py login   # 登录京东（只需一次）
  python3 fetch_images.py fetch   # 抓取产品图片
""")
