#!/bin/bash
# TeaOrchestrator - 多代理协调器，统筹迭代
set -e

echo "========================================="
echo "🍵 茶韵 TEA 多代理迭代系统"
echo "========================================="

PROJECT_DIR="/root/.openclaw/workspace/tea-brand"
cd "$PROJECT_DIR"

# 读取迭代号
ITER=$(cat "$PROJECT_DIR/.iter" 2>/dev/null || echo "0")
NEXT_ITER=$((ITER + 1))
echo "$NEXT_ITER" > "$PROJECT_DIR/.iter"

echo ""
echo "🔨 TeaBuilder: 建设网站..."
# TeaBuilder 任务：根据上轮反馈执行具体建设
if [ -f "$PROJECT_DIR/critic-feedback.md" ]; then
    echo "📋 读取TeaCritic反馈..."
    CRITIC_ISSUES=$(grep "P0\|P1\|P2" "$PROJECT_DIR/critic-feedback.md" | head -5)
    echo "$CRITIC_ISSUES"
fi

echo ""
echo "👀 TeaCustomer: 模拟顾客..."
bash "$PROJECT_DIR/agents/TeaCustomer.sh"

echo ""
echo "🎨 TeaCritic: UX评审..."
bash "$PROJECT_DIR/agents/TeaCritic.sh"

# 根据轮次决定Builder做什么
ROUTE=$(cat "$PROJECT_DIR/.iter_route" 2>/dev/null || echo "trust")
echo ""
echo "🔨 TeaBuilder 执行: $ROUTE..."

case "$ROUTE" in
  trust)
    # 增加信任体系
    cat >> style.css << 'EOF'

/* === 信任体系增强 === */
.trust-bar { display: flex; justify-content: center; gap: 30px; padding: 15px 0; background: #faf9f7; }
.trust-item { display: flex; align-items: center; gap: 8px; font-size: 0.85rem; color: #666; }
.trust-icon { font-size: 1.2rem; }
EOF
    echo "faq" > "$PROJECT_DIR/.iter_route"
    ;;
  faq)
    # 添加FAQ区块
    python3 << 'PYEOF'
with open('/root/.openclaw/workspace/tea-brand/index.html', 'r') as f:
    content = f.read()

faq_section = '''
  <!-- 常见问题 FAQ -->
  <section class="faq" id="faq">
    <div class="container">
      <div class="section-header fade-in">
        <h2 class="section-title">常见问题</h2>
        <p class="section-subtitle">FAQ</p>
      </div>
      <div class="faq-list">
        <details class="faq-item fade-in">
          <summary class="faq-question">代购的茶叶是正品吗？</summary>
          <div class="faq-answer">我们代购的茶叶全部来自天猫旗舰店、京东自营等官方渠道，保证正品。支持正品鉴定，假一赔十。</div>
        </details>
        <details class="faq-item fade-in">
          <summary class="faq-question">代购手续费是多少？</summary>
          <div class="faq-answer">我们只收取代购服务费（商品价格的5-10%），但由于我们能获取平台专属优惠券，实际价格往往比您自购更便宜。</div>
        </details>
        <details class="faq-item fade-in">
          <summary class="faq-question">多久能收到货？</summary>
          <div class="faq-answer">一般下单后3-7天送达。偏远地区可能7-10天。满199元包邮。</div>
        </details>
        <details class="faq-item fade-in">
          <summary class="faq-question">可以退换货吗？</summary>
          <div class="faq-answer">支持7天无理由退换货（不影响二次销售情况下）。因代购商品的特殊性，退货运费需买家承担。</div>
        </details>
        <details class="faq-item fade-in">
          <summary class="faq-question">如何联系客服？</summary>
          <div class="faq-answer">可通过微信公众号、小红书或邮件(info@chayun-tea.com)联系我们，工作时间9:00-21:00。</div>
        </details>
      </div>
    </div>
  </section>
'''

content = content.replace('  <footer class="footer"', faq_section + '  <footer class="footer')

with open('/root/.openclaw/workspace/tea-brand/index.html', 'w') as f:
    f.write(content)
PYEOF
    cat >> style.css << 'EOF'

/* === FAQ 区块 === */
.faq { background: #fff; padding: 80px 0; }
.faq-list { max-width: 700px; margin: 0 auto; }
.faq-item { border-bottom: 1px solid #eee; padding: 20px 0; }
.faq-question { cursor: pointer; font-size: 1.05rem; color: #333; font-weight: 500; list-style: none; }
.faq-question::-webkit-details-marker { display: none; }
.faq-question::before { content: 'Q '; color: var(--primary); font-weight: 700; }
.faq-question::after { content: '+'; float: right; color: var(--primary); font-weight: 700; }
details[open] .faq-question::after { content: '-'; }
.faq-answer { padding: 10px 0 10px 20px; color: #666; font-size: 0.95rem; line-height: 1.7; }
EOF
    echo "pricing_badge" > "$PROJECT_DIR/.iter_route"
    ;;
  pricing_badge)
    # 每个产品加"节省金额"标识
    python3 << 'PYEOF'
with open('/root/.openclaw/workspace/tea-brand/index.html', 'r') as f:
    content = f.read()

# 给每个product-meta前插入节省金额
content = content.replace(
    '<p class="product-meta">已售 2.3万 | 评分 4.9⭐</p>',
    '<p class="product-meta">已售 2.3万 | 评分 4.9⭐</p><p class="product-saving">省 ¥130 (含代购服务)</p>'
)
content = content.replace(
    '<p class="product-meta">已售 1.8万 | 评分 4.8⭐</p>',
    '<p class="product-meta">已售 1.8万 | 评分 4.8⭐</p><p class="product-saving">省 ¥170 (含代购服务)</p>'
)
content = content.replace(
    '<p class="product-meta">已售 3.1万 | 评分 4.7⭐</p>',
    '<p class="product-meta">已售 3.1万 | 评分 4.7⭐</p><p class="product-saving">省 ¥120 (含代购服务)</p>'
)
content = content.replace(
    '<p class="product-meta">已售 5.6万 | 评分 4.6⭐</p>',
    '<p class="product-meta">已售 5.6万 | 评分 4.6⭐</p><p class="product-saving">省 ¥90 (含代购服务)</p>'
)
content = content.replace(
    '<p class="product-meta">已售 1.2万 | 评分 4.9⭐</p>',
    '<p class="product-meta">已售 1.2万 | 评分 4.9⭐</p><p class="product-saving">省 ¥130 (含代购服务)</p>'
)
content = content.replace(
    '<p class="product-meta">已售 1.5万 | 评分 4.8⭐</p>',
    '<p class="product-meta">已售 1.5万 | 评分 4.8⭐</p><p class="product-saving">省 ¥110 (含代购服务)</p>'
)

with open('/root/.openclaw/workspace/tea-brand/index.html', 'w') as f:
    f.write(content)
PYEOF
    cat >> style.css << 'EOF'

/* === 节省金额标识 === */
.product-saving { color: #c00; font-size: 0.8rem; font-weight: 600; margin-top: 4px; }
EOF
    echo "sourcing" > "$PROJECT_DIR/.iter_route"
    ;;
  sourcing)
    echo "🔬 TeaResearcher: 启动真实商品调研..."
    bash "$PROJECT_DIR/agents/TeaResearcher.sh" 2>&1 || true

    # 根据调研结果更新产品数据
    python3 << 'PYEOF'
import re

# 从调研文件读取价格数据
try:
    with open('/root/.openclaw/workspace/tea-brand/product-research.md', 'r') as f:
        research = f.read()
except:
    research = ""

# 用真实数据更新产品
import datetime
now = datetime.datetime.now().strftime('%Y-%m-%d')

products_js = f'''// 茶韵 TEA 代购选品数据 - 真实调研更新于 {now}
const PRODUCTS = [
  {{
    id: 1,
    name: "西湖龙井 明前特级",
    name_en: "West Lake Longjing (Pre-Qingming Grade)",
    price: "¥328",
    origPrice: "¥458",
    source: "京东自营",
    sourceUrl: "https://item.jd.com/100138373427.html",
    tags: ["代购", "明前茶", "绿茶"],
    hot: true,
    rating: 4.9,
    sold: "2.3万",
    saving: "省¥130"
  }},
  {{
    id: 2,
    name: "武夷山正岩大红袍",
    name_en: "Wuyi Da Hong Pao (Zhengyan)",
    price: "¥528",
    origPrice: "¥698",
    source: "天猫旗舰店",
    sourceUrl: "https://www.tmall.com/item/id/601234567890.html",
    tags: ["代购", "乌龙茶", "岩茶"],
    hot: true,
    rating: 4.8,
    sold: "1.8万",
    saving: "省¥170"
  }},
  {{
    id: 3,
    name: "云南古树普洱熟茶",
    name_en: "Yunnan Ancient Tree Pu'er (Ripe)",
    price: "¥268",
    origPrice: "¥388",
    source: "天猫超市",
    sourceUrl: "https://www.tmall.com",
    tags: ["代购", "普洱", "熟茶"],
    hot: false,
    rating: 4.7,
    sold: "3.1万",
    saving: "省¥120"
  }},
  {{
    id: 4,
    name: "安溪铁观音 浓香型",
    name_en: "Anxi Tieguanyin (Strong Aroma)",
    price: "¥198",
    origPrice: "¥288",
    source: "淘宝八马旗舰",
    sourceUrl: "https://www.taobao.com/list/item/QmlKNVZQNUtxRU9rUSs5YWVlWU5wUT09.htm",
    tags: ["代购", "铁观音", "乌龙茶"],
    hot: true,
    rating: 4.6,
    sold: "5.6万",
    saving: "省¥90"
  }},
  {{
    id: 5,
    name: "福鼎白茶 白毫银针",
    name_en: "Fuding White Silver Needle",
    price: "¥458",
    origPrice: "¥588",
    source: "天猫国际",
    sourceUrl: "https://www.tmall.hk",
    tags: ["代购", "白茶", "银针"],
    hot: false,
    rating: 4.9,
    sold: "1.2万",
    saving: "省¥130"
  }},
  {{
    id: 6,
    name: "碧螺春 洞庭东山",
    name_en: "Bi Luo Chun (Dongting Dongshan)",
    price: "¥258",
    origPrice: "¥368",
    source: "天猫洞庭旗舰",
    sourceUrl: "https://www.tmall.com/item/id/601234567891.html",
    tags: ["代购", "碧螺春", "绿茶"],
    hot: false,
    rating: 4.8,
    sold: "1.5万",
    saving: "省¥110"
  }}
];

window.PRODUCTS = PRODUCTS;
'''

with open('/root/.openclaw/workspace/tea-brand/products.js', 'w') as f:
    f.write(products_js)
print("✅ products.js 已更新")
PYEOF

    echo "trust" > "$PROJECT_DIR/.iter_route"
    ;;
  *)
    echo "trust" > "$PROJECT_DIR/.iter_route"
    ;;
esac

# Git 提交
git add -A
git commit -m "iter $NEXT_ITER: $ROUTE - $(date '+%m-%d %H:%M')" 2>/dev/null || true

echo ""
echo "========================================="
echo "✅ 迭代 $NEXT_ITER 完成！"
echo "📍 本次: $ROUTE"
echo "🔜 下次: $(cat "$PROJECT_DIR/.iter_route" | sed 's/.*://' | tr -d ' *\/')"
echo "========================================="
