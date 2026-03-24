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
    if ! grep -q "transition.*0.3s" style.css; then
      cat >> style.css << 'EOF'

/* === 迭代增强 === */
.product-card:hover { transform: translateY(-8px); box-shadow: 0 12px 40px rgba(74,124,89,0.15); }
.fade-in { animation: fadeIn 0.6s ease-out forwards; }
@keyframes fadeIn { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }
EOF
    fi
    echo "/* 下次路线: content */" > "$ROUTE_FILE"
    ;;
  content)
    echo "[迭代 $NEXT_ITER] 改进内容..."
    if ! grep -q "茶韵 TEA" index.html; then
      sed -i 's/茶韵/茶韵 TEA/g' index.html
    fi
    echo "/* 下次路线: mobile */" > "$ROUTE_FILE"
    ;;
  mobile)
    echo "[迭代 $NEXT_ITER] 改进移动端适配..."
    if ! grep -q "@media (max-width: 480px)" style.css; then
      cat >> style.css << 'EOF'

/* === 移动端适配 === */
@media (max-width: 480px) {
  .hero h1 { font-size: 2.5rem; }
  .product-grid { grid-template-columns: 1fr !important; }
  .nav-links { display: none; }
}
EOF
    fi
    echo "/* 下次路线: perf */" > "$ROUTE_FILE"
    ;;
  perf)
    echo "[迭代 $NEXT_ITER] 优化性能..."
    if grep -q "fonts.googleapis.com" index.html; then
      sed -i 's|<link rel="stylesheet"|<link rel="preconnect" href="https://fonts.googleapis.com">\n<link rel="stylesheet"|g' index.html
    fi
    echo "/* 下次路线: sourcing */" > "$ROUTE_FILE"
    ;;
  sourcing)
    echo "[迭代 $NEXT_ITER] 代购选品更新..."
    # 更新 products.js 中的代购产品数据
    cat > "$PROJECT_DIR/products.js" << 'EOF'
// 茶韵 TEA 代购选品数据 - 自动更新
const PRODUCTS = [
  {
    id: 1,
    name: "西湖龙井 明前特级",
    name_en: "West Lake Longjing (Pre-Qingming Grade)",
    price: "¥328",
    origPrice: "¥458",
    source: "天猫超市",
    sourceUrl: "https://chaoshi.tmall.com",
    tags: ["代购", "明前茶", "绿茶"],
    hot: true,
    rating: 4.9,
    sold: "2.3万"
  },
  {
    id: 2,
    name: "武夷山正岩大红袍",
    name_en: "Wuyi Da Hong Pao (Zhengyan)",
    price: "¥528",
    origPrice: "¥698",
    source: "京东自营",
    sourceUrl: "https://jd.com",
    tags: ["代购", "乌龙茶", "岩茶"],
    hot: true,
    rating: 4.8,
    sold: "1.8万"
  },
  {
    id: 3,
    name: "云南古树普洱熟茶",
    name_en: "Yunnan Ancient Tree Pu'er (Ripe)",
    price: "¥268",
    origPrice: "¥388",
    source: "拼多多",
    sourceUrl: "https://pinduoduo.com",
    tags: ["代购", "普洱", "熟茶"],
    hot: false,
    rating: 4.7,
    sold: "3.1万"
  },
  {
    id: 4,
    name: "福鼎白茶 白毫银针",
    name_en: "Fuding White Silver Needle",
    price: "¥458",
    origPrice: "¥588",
    source: "天猫国际",
    sourceUrl: "https://tmall.hk",
    tags: ["代购", "白茶", "银针"],
    hot: false,
    rating: 4.9,
    sold: "1.2万"
  },
  {
    id: 5,
    name: "安溪铁观音 浓香型",
    name_en: "Anxi Tieguanyin (Strong Aroma)",
    price: "¥198",
    origPrice: "¥288",
    source: "淘宝心选",
    sourceUrl: "https://taobao.com",
    tags: ["代购", "铁观音", "乌龙茶"],
    hot: true,
    rating: 4.6,
    sold: "5.6万"
  },
  {
    id: 6,
    name: "碧螺春 洞庭东山",
    name_en: "Bi Luo Chun (Dongting Dongshan)",
    price: "¥258",
    origPrice: "¥368",
    source: "网易严选",
    sourceUrl: "https://yanxuan.com",
    tags: ["代购", "碧螺春", "绿茶"],
    hot: false,
    rating: 4.8,
    sold: "1.5万"
  }
];

window.PRODUCTS = PRODUCTS;
EOF

    # 更新 index.html 中的产品区，引入 products.js
    if ! grep -q "products.js" index.html; then
      sed -i 's|</body>|<script src="products.js"></script>\n</body>|' index.html
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
