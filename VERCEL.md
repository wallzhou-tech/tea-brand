# 🍵 Vercel 一键部署指南

## 方案一：Vercel CLI 部署（推荐）

```bash
# 1. 安装 Vercel CLI
npm i -g vercel

# 2. 登录 Vercel
vercel login

# 3. 进入项目目录并部署
cd /root/.openclaw/workspace/tea-brand
vercel

# 4. 生产环境部署
vercel --prod
```

## 方案二：GitHub 一键导入

1. 打开 [vercel.com/new](https://vercel.com/new)
2. 点击 "Import Git Repository"
3. 选择 `wallzhou-tech/tea-brand`
4. Framework Preset 选择 `Vite`
5. Root Directory 保持默认 `./`
6. 点击 "Deploy"

## 方案三：vercel.json 配置

项目已包含 `vercel.json`（如需），覆盖以下配置：

```json
{
  "buildCommand": "npm run build",
  "outputDirectory": "dist",
  "framework": "vite",
  "rewrites": [
    { "source": "/(.*)", "destination": "/index.html" }
  ]
}
```

## 自定义域名配置

### 通过 Vercel Dashboard

1. 进入项目 → Settings → Domains
2. 添加你的域名（如 `tea.yourdomain.com`）
3. 按提示在 DNS 添加记录：
   ```
   # CNAME 记录
   记录名: tea
   类型: CNAME
   值: cname.vercel-dns.com
   ```
4. 等待 DNS 生效（通常 5-10 分钟）

### 通过 CLI

```bash
vercel domains add tea.yourdomain.com
```

## 环境变量

如需环境变量：
```bash
# 通过 CLI
vercel env add VITE_API_BASE_URL

# 或在 Dashboard → Settings → Environment Variables 添加
```

## 预览部署

```bash
# 生成预览链接
vercel preview
```

---

**Vercel 优势：**
- ✅ 免费套餐足够个人/小项目使用
- ✅ 全球 CDN，访问速度快
- ✅ 自动 HTTPS
- ✅ 预览部署方便协作
