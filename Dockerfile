# Stage 1: Build
FROM node:20-alpine AS builder # <-- Sửa thành Node 20

WORKDIR /app
COPY package.json package-lock.json ./

# Không cần cập nhật npm vì Node 20 đã đi kèm npm tương thích
RUN npm ci --production

COPY . .
RUN npm run build

# Stage 2: Production
FROM node:20-alpine # <-- Sửa thành Node 20
WORKDIR /app
COPY --from=builder /app .

CMD ["sh", "-c", "medusa migrate && medusa start"]