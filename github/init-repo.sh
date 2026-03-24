#!/usr/bin/env bash
# ==================== TeaBrand GitHub 仓库初始化脚本 ====================
# 用法: bash github/init-repo.sh

set -e

REPO_NAME="tea-brand"
GITHUB_USER="wallzhou-tech"  # 修改为你的 GitHub 用户名

echo "🍵 茶叶文化品牌 - GitHub 仓库初始化"
echo "=================================="

# 1. 检查 gh CLI 是否登录
echo "[1/5] 检查 GitHub 登录状态..."
gh auth status || { echo "❌ 请先运行 gh auth login"; exit 1; }

# 2. 创建远程仓库（如果不存在）
echo "[2/5] 创建 GitHub 仓库..."
if gh repo view "$GITHUB_USER/$REPO_NAME" &>/dev/null; then
    echo "✅ 仓库 $GITHUB_USER/$REPO_NAME 已存在"
else
    gh repo create "$REPO_NAME" --public --description "🍵 茶叶文化品牌官网 - 传承千年茶文化" --source=. --push
    echo "✅ 仓库创建成功"
fi

# 3. 配置 GitHub Pages
echo "[3/5] 配置 GitHub Pages..."
gh api repos/"$GITHUB_USER"/"$REPO_NAME"/pages \
    --method POST \
    --field build_type=workflow \
    --field source[branch]=gh-pages \
    --field source[path]=/ 2>/dev/null || echo "ℹ️ Pages 可能已配置或无权限，跳过"

# 4. 配置分支保护
echo "[4/5] 配置 main 分支保护..."
gh api repos/"$GITHUB_USER"/"$REPO_NAME"/branches/main/protection \
    --method PUT \
    --header "Accept: application/vnd.github.v3+json" \
    --field required_status_checks='{"strict":true,"contexts":[]}' \
    --field enforce_admins=true \
    --field required_pull_request_reviews='{"required_reviewers":[],"require_last_push_approval":true}' \
    --field allow_force_pushes=false \
    2>/dev/null || echo "ℹ️ 分支保护跳过（需要管理员权限）"

# 5. 添加 secrets（可选）
echo "[5/5] 环境检查..."
echo "✅ 当前仓库地址: https://github.com/$GITHUB_USER/$REPO_NAME"
echo "✅ GitHub Pages 将从 gh-pages 分支部署"
echo ""
echo "📋 下一步操作:"
echo "   1. 推送代码到 main 分支: git push origin main"
echo "   2. GitHub Actions 将自动构建并部署到 GitHub Pages"
echo "   3. 等待约 2 分钟后访问: https://$GITHUB_USER.github.io/$REPO_NAME"
echo ""
echo "🍵 初始化完成！"
