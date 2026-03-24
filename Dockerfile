# ==================== TeaBrand Nginx Docker ====================
# 多阶段构建：减小镜像体积

# ---------- 构建阶段 ----------
FROM node:22-alpine AS builder

WORKDIR /app

# 复制依赖文件
COPY package*.json ./

# 安装依赖
RUN npm ci --prefer-offline

# 复制源代码
COPY . .

# 构建项目（根据实际构建命令调整）
RUN npm run build

# ---------- 生产阶段 ----------
FROM nginx:1.27-alpine AS production

# 移除默认配置
RUN rm /etc/nginx/conf.d/default.conf

# 复制自定义 Nginx 配置
COPY nginx.conf /etc/nginx/conf.d/

# 从构建阶段复制构建产物
COPY --from=builder /app/dist /usr/share/nginx/html

# 暴露端口
EXPOSE 80

# 健康检查
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost/ || exit 1

# 启动 Nginx
CMD ["nginx", "-g", "daemon off;"]
