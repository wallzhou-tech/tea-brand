#!/bin/bash
# 茶叶品牌网站迭代脚本 - 每次小改进，留给下次空间
set -e

PROJECT_DIR="/root/.openclaw/workspace/tea-brand"
cd "$PROJECT_DIR"

# 读取当前迭代序号
ITER_FILE="$PROJECT_DIR/.iter"
CURRENT_ITER=$(cat "$ITER_FILE" 2>/dev/null || echo "0")
NEXT_ITER=$((CURRENT_ITER + 1))
echo "$NEXT_ITER" > "$ITER_FILE"

echo "[迭代 $NEXT_ITER] 开始..."

# 读取上次预留的迭代路线
ROUTE_FILE="$PROJECT_DIR/.iter_route"
ROUTE=$(cat "$ROUTE_FILE" 2>/dev/null || echo "ui")

case "$ROUTE" in
  ui)
    echo "[迭代 $NEXT_ITER] 改进 UI/样式..."
    # 检查 index.html 和 style.css，做渐进式改进
    if ! grep -q "transition.*0.3s" style.css; then
      echo "/* 增强悬停动画 */" >> style.css
      echo ".product-card:hover { transform: translateY(-8px); box-shadow: 0 12px 40px rgba(74,124,89,0.15); }" >> style.css
      echo ".fade-in { animation: fadeIn 0.6s ease-out forwards; }" >> style.css
      echo "/* 下次路线: content */" > "$ROUTE_FILE"
    else
      echo "/* 下次路线: content */" > "$ROUTE_FILE"
    fi
    ;;
  content)
    echo "[迭代 $NEXT_ITER] 改进内容..."
    # 检查 content.md 是否已整合到 index.html
    if ! grep -q "茶韵 TEA" index.html; then
      sed -i 's/茶韵/茶韵 TEA/g' index.html
    fi
    echo "/* 下次路线: mobile */" > "$ROUTE_FILE"
    ;;
  mobile)
    echo "[迭代 $NEXT_ITER] 改进移动端适配..."
    # 检查响应式断点
    if ! grep -q "@media (max-width: 480px)" style.css; then
      echo "@media (max-width: 480px) { .hero h1 { font-size: 2.5rem; } }" >> style.css
    fi
    echo "/* 下次路线: perf */" > "$ROUTE_FILE"
    ;;
  perf)
    echo "[迭代 $NEXT_ITER] 优化性能..."
    # 检查是否用了 Google Fonts 本地化
    if grep -q "fonts.googleapis.com" index.html; then
      # 添加字体预加载
      sed -i 's|<link rel="stylesheet"|<link rel="preconnect" href="https://fonts.googleapis.com">\n<link rel="stylesheet"|g' index.html
    fi
    echo "/* 下次路线: ui */" > "$ROUTE_FILE"
    ;;
  *)
    echo "/* 下次路线: ui */" > "$ROUTE_FILE"
    ;;
esac

# Git 提交
git add -A
git commit -m "iter $NEXT_ITER: $ROUTE - $(date '+%m-%d %H:%M')" 2>/dev/null || true

echo "[迭代 $NEXT_ITER] 完成！下次路线: $(cat "$ROUTE_FILE")"
