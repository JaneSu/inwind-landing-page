# 构建阶段
FROM node:18-alpine AS builder

WORKDIR /app
COPY . .

# 安装依赖并构建
RUN npm install
RUN npm run build

# 运行阶段
FROM node:18-alpine AS runner

WORKDIR /app

# 从构建阶段复制必要文件
COPY --from=builder /app/next.config.js ./
COPY --from=builder /app/public ./public
COPY --from=builder /app/.next/standalone ./
COPY --from=builder /app/.next/static ./.next/static

# 设置环境变量
ENV PORT=8080
ENV NODE_ENV=production
ENV HOST=0.0.0.0

EXPOSE 8080

# 启动服务
CMD ["node", "server.js"] 