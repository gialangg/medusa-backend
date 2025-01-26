# Stage 1: Build
FROM node:20-alpine AS builder

WORKDIR /app
COPY package.json package-lock.json ./

# Cài đặt cả production và dev dependencies
RUN npm ci

# Cài đặt Medusa CLI và dotenv globally
RUN npm install -g @medusajs/medusa-cli dotenv

COPY . .
RUN npm run build

# Stage 2: Production
FROM node:20-alpine
WORKDIR /app

# Copy các file cần thiết
COPY --from=builder /app .
COPY --from=builder /usr/local/lib/node_modules /usr/local/lib/node_modules
COPY --from=builder /usr/local/bin/medusa /usr/local/bin/medusa

# Copy file .env (nếu có)
COPY .env ./

# Cấu hình PATH
ENV PATH="/usr/local/bin:${PATH}"

CMD ["sh", "-c", "medusa migrate && medusa start"]