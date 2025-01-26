# Stage 1: Build
FROM node:20-alpine AS builder

WORKDIR /app
COPY package.json package-lock.json ./

# Cài đặt dependencies và Medusa CLI LOCAL (không global)
RUN npm ci --include=dev

COPY . .
RUN npm run build

# Stage 2: Production
FROM node:20-alpine
WORKDIR /app

# Copy chỉ những gì cần thiết
COPY --from=builder /app .
COPY --from=builder /app/node_modules ./node_modules

# Sử dụng Medusajs CLI từ node_modules/.bin
CMD ["sh", "-c", "npx medusa migrate && npx medusa start"]