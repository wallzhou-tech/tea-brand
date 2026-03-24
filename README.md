# 茶韵 TEA - 官方网站

> 传承五千年茶文化，以东方禅意与现代简约融合，为您呈现极致茶道体验。

## 🌿 项目介绍

茶韵 TEA 是一个茶叶文化品牌官网，采用东方禅意与现代简约风格设计。网站展示茶叶文化、精选产品，并提供茶文化科普知识。

## ✨ 特色功能

- **Hero 区域**：渐变背景 + 动态滚动提示
- **茶文化介绍**：茶史、茶道、茶艺三大主题卡片
- **产品展示**：6款精选茶叶产品展示
- **茶文化科普**：四季饮茶指南、泡茶水温等实用知识
- **响应式设计**：完美适配桌面、平板、手机
- **淡入动画**：滚动时元素平滑淡入
- **中英双语**：国际化设计

## 🛠 技术栈

- **HTML5**：语义化标签
- **CSS3**：Flexbox + Grid 布局，CSS 变量
- **JavaScript**：原生 JS，无框架依赖
- **字体**：Google Fonts (Noto Serif SC + Inter)

## 📁 文件结构

```
tea-brand/
├── index.html    # 主页面
├── style.css     # 样式表
├── SPEC.md       # 项目规格说明
└── README.md     # 项目说明文档
```

## 🚀 快速开始

1. 克隆项目
```bash
git clone <repository-url>
cd tea-brand
```

2. 直接在浏览器中打开 `index.html`

或使用本地服务器：

```bash
# Python 3
python -m http.server 8000

# Node.js
npx serve
```

然后访问 `http://localhost:8000`

## 🎨 设计规范

### 色彩系统

| 颜色 | 色值 | 用途 |
|------|------|------|
| 茶绿 | `#4A7C59` | 主色调 |
| 浅茶绿 | `#6B9E7A` | 辅助色 |
| 米白 | `#F5F0E8` | 背景色 |
| 古铜金 | `#B8956B` | 强调色 |

### 响应式断点

| 设备 | 断点 |
|------|------|
| 桌面 | ≥1025px |
| 平板 | 768px - 1024px |
| 手机 | < 768px |

## 📱 浏览器兼容性

- Chrome 80+
- Firefox 75+
- Safari 13+
- Edge 80+

## 🔧 自定义

### 修改颜色

编辑 `style.css` 中的 CSS 变量：

```css
:root {
  --color-primary: #4A7C59;
  --color-cream: #F5F0E8;
  /* ... */
}
```

### 添加产品

在 `index.html` 中找到 `<!-- 产品展示区 -->`，复制产品卡片模板并修改内容：

```html
<div class="product-card fade-in">
  <div class="product-image">
    <div class="product-placeholder">新品</div>
  </div>
  <div class="product-info">
    <h3 class="product-name">新品名称</h3>
    <p class="product-name-en">New Product Name</p>
    <p class="product-price">¥XXX / XXXg</p>
  </div>
</div>
```

## 📄 License

MIT License
