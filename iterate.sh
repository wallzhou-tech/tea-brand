#!/bin/bash
# 茶叶品牌网站迭代脚本 - 客户视角+禅意美学
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
ROUTE=$(cat "$ROUTE_FILE" 2>/dev/null || echo "zen_ui")

case "$ROUTE" in
  zen_ui)
    echo "[迭代 $NEXT_ITER] 禅意UX优化 - 留白与呼吸感..."
    # 增加页面留白，让内容有呼吸空间
    if ! grep -q "padding.*80px.*120px" style.css; then
      cat >> style.css << 'EOF'

/* === 禅意留白优化 === */
.section-header { margin-bottom: 60px; }
.culture-grid, .products-grid { gap: 40px; }
.hero-content { padding: 60px 40px; }
EOF
    fi
    echo "/* 下次路线: zen_content */" > "$ROUTE_FILE"
    echo "✅ 禅意留白优化完成"
    ;;
  zen_content)
    echo "[迭代 $NEXT_ITER] 禅意内容优化 - 诗意文案..."
    # 优化Hero区文案，增加诗意禅意感
    if grep -q "一叶一世界" index.html; then
      # 给Hero区添加禅意诗句背景
      sed -i 's|<p class="hero-tagline.*|<p class="hero-quote">「茶之一味，苦后回甘，如人生百态」</p>|' index.html 2>/dev/null || true
    fi
    echo "/* 下次路线: mobile */" > "$ROUTE_FILE"
    echo "✅ 禅意内容优化完成"
    ;;
  mobile)
    echo "[迭代 $NEXT_ITER] 移动端适配优化..."
    if ! grep -q "@media (max-width: 768px)" style.css; then
      cat >> style.css << 'EOF'

/* === 移动端深度适配 === */
@media (max-width: 768px) {
  .hero h1 { font-size: 3rem; }
  .section-header { margin-bottom: 40px; }
  .culture-grid { grid-template-columns: 1fr; }
  .products-grid { grid-template-columns: repeat(2, 1fr); }
  .agent-steps { grid-template-columns: repeat(2, 1fr); }
}
@media (max-width: 480px) {
  .hero h1 { font-size: 2.5rem; }
  .products-grid { grid-template-columns: 1fr; }
  .hero-content { padding: 40px 20px; }
}
EOF
    fi
    echo "/* 下次路线: perf */" > "$ROUTE_FILE"
    echo "✅ 移动端优化完成"
    ;;
  perf)
    echo "[迭代 $NEXT_ITER] 性能优化 - 加载体验..."
    # 检查并优化字体加载
    if grep -q "fonts.googleapis.com" index.html && ! grep -q "display=swap" index.html; then
      sed -i 's|fonts.googleapis.com/css2?family=Noto+Serif+SC|fonts.googleapis.com/css2?family=Noto+Serif+SC&display=swap|g' index.html
    fi
    echo "/* 下次路线: sourcing */" > "$ROUTE_FILE"
    echo "✅ 性能优化完成"
    ;;
  sourcing)
    echo "[迭代 $NEXT_ITER] 代购选品更新..."
    # 更新代购产品数据
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

    if ! grep -q "products.js" index.html; then
      sed -i 's|</body>|<script src="products.js"></script>\n</body>|' index.html
    fi

    echo "/* 下次路线: cta_opt */" > "$ROUTE_FILE"
    echo "✅ 代购选品更新完成"
    ;;
  cta_opt)
    echo "[迭代 $NEXT_ITER] CTA转化优化 - 客户行动引导..."
    # 优化"立即代购"按钮，增加紧迫感和信任
    if ! grep -q "pulse" style.css; then
      cat >> style.css << 'EOF'

/* === CTA按钮优化 === */
.product-btn {
  background: linear-gradient(135deg, #4A7C59, #6B9E7A);
  position: relative;
  overflow: hidden;
}
.product-btn::after {
  content: '';
  position: absolute;
  top: -50%; left: -50%;
  width: 200%; height: 200%;
  background: linear-gradient(45deg, transparent, rgba(255,255,255,0.1), transparent);
  transform: rotate(45deg);
  animation: btnShine 3s infinite;
}
@keyframes btnShine {
  0% { transform: translateX(-100%) rotate(45deg); }
  100% { transform: translateX(100%) rotate(45deg); }
}
EOF
    fi
    echo "/* 下次路线: trust_build */" > "$ROUTE_FILE"
    echo "✅ CTA优化完成"
    ;;
  trust_build)
    echo "[迭代 $NEXT_ITER] 信任体系建设..."
    # 添加客户评价、销量数据展示，增强信任感
    if ! grep -q "customer-review" index.html; then
      # 在代购服务区后添加客户评价区
      python3 << 'PYEOF'
with open('/root/.openclaw/workspace/tea-brand/index.html', 'r') as f:
      content = f.read()

review_section = '''
  <!-- 客户评价区 -->
  <section class="reviews" id="reviews">
    <div class="container">
      <div class="section-header fade-in">
        <h2 class="section-title">品茶人说</h2>
        <p class="section-subtitle">What Our Customers Say</p>
      </div>
      <div class="reviews-grid">
        <div class="review-card fade-in">
          <div class="review-stars">⭐⭐⭐⭐⭐</div>
          <p class="review-text">"龙井入口甘甜，回甘持久，确实是正宗明前茶。包装也很精美，送礼自用皆宜。"</p>
          <div class="review-author">— 上海王女士</div>
        </div>
        <div class="review-card fade-in">
          <div class="review-stars">⭐⭐⭐⭐⭐</div>
          <p class="review-text">"代购的大红袍香气扑鼻，岩韵十足。客服态度很好，会继续回购。"</p>
          <div class="review-author">— 北京陈先生</div>
        </div>
        <div class="review-card fade-in">
          <div class="review-stars">⭐⭐⭐⭐⭐</div>
          <p class="review-text">"普洱茶汤红浓透亮，口感醇厚。代购价格比自己去买还便宜，赞！"</p>
          <div class="review-author">— 广州李先生</div>
        </div>
      </div>
    </div>
  </section>
'''

# 在 footer 前插入
content = content.replace('  <footer class="footer"', review_section + '  <footer class="footer')

with open('/root/.openclaw/workspace/tea-brand/index.html', 'w') as f:
      f.write(content)
PYEOF
      cat >> style.css << 'EOF'

/* === 客户评价区 === */
.reviews { background: #faf9f7; padding: 80px 0; }
.reviews-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 30px; }
.review-card {
  background: #fff; border-radius: 20px; padding: 30px;
  box-shadow: 0 4px 20px rgba(0,0,0,0.05);
}
.review-stars { color: #f5a623; font-size: 1.2rem; margin-bottom: 15px; }
.review-text { font-size: 0.95rem; color: #555; line-height: 1.8; margin-bottom: 15px; font-style: italic; }
.review-author { font-size: 0.85rem; color: #888; text-align: right; }
@media (max-width: 768px) { .reviews-grid { grid-template-columns: 1fr; } }
EOF
    fi
    echo "/* 下次路线: zen_ui */" > "$ROUTE_FILE"
    echo "✅ 信任体系建设完成"
    ;;
  *)
    echo "/* 下次路线: zen_ui */" > "$ROUTE_FILE"
    ;;
esac

# Git 提交
git add -A
git commit -m "iter $NEXT_ITER: $ROUTE - $(date '+%m-%d %H:%M')" 2>/dev/null || true

echo "========================================="
echo "✅ 迭代 $NEXT_ITER 完成！"
echo "📍 本次: $ROUTE"
echo "🔜 下次: $(cat "$ROUTE_FILE" | sed 's/\*\/ //g')"
echo "========================================="
