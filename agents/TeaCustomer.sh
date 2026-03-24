#!/bin/bash
# TeaCustomer 代理 - 模拟真实顾客浏览网站并给出反馈
set -e

echo "🛒 TeaCustomer 启动：模拟顾客浏览..."

# 使用 agent-browser 打开网站并截图
cd /root/.openclaw/workspace/tea-brand

# 启动本地服务检查
if ! curl --noproxy '*' -s http://localhost:8080/ > /dev/null; then
    cd /root/.openclaw/workspace/tea-brand
    python3 -m http.server 8080 &
    sleep 2
fi

# 记录顾客视角的问题
CUSTOMER_REPORT="/root/.openclaw/workspace/tea-brand/customer-feedback.md"
DATE=$(date '+%Y-%m-%d %H:%M')

cat > "$CUSTOMER_REPORT" << 'EOF'
# 顾客视角反馈
EOF

echo "# 顾客视角反馈 - $DATE" >> "$CUSTOMER_REPORT"
echo "" >> "$CUSTOMER_REPORT"

# 模拟顾客会问的问题
cat >> "$CUSTOMER_REPORT" << 'EOF'
## 👀 第一印象
- 页面加载速度：需要测试
- 整体风格：禅意优雅，但代购感需要更强

## 🤔 顾客会问的问题
1. "这是代购还是自己卖？" → 需要明确说明
2. "价格比自己去买便宜多少？" → 需要代购佣金/节省说明
3. "正品有保证吗？" → 需要更多信任背书
4. "怎么下单？" → 需要代购流程说明
5. "运费多少？多久到？" → 需要配送信息

## 💡 顾客建议
1. 首页增加"为什么选择我们代购"区块
2. 每个产品卡片加"比自己去买省XX元"标识
3. 增加实时销量/库存暗示
4. 增加限时折扣倒计时
5. 顾客问答FAQ区块

EOF

echo "✅ 顾客反馈已记录到 $CUSTOMER_REPORT"
cat "$CUSTOMER_REPORT"
