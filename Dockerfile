# Stage 1: Build
FROM node:18-alpine AS builder

WORKDIR /app
COPY package*.json ./
COPY medusa-config.ts ./

# Cài đặt cả devDependencies để build
RUN npm ci

COPY . .
RUN npm run build

# Stage 2: Production
FROM node:18-alpine

WORKDIR /app

# Copy từ builder
COPY --from=builder /app .
COPY --from=builder /app/node_modules ./node_modules  # Quan trọng: Copy node_modules

# Cài đặt Medusa CLI globally
RUN npm install -g @medusajs/medusa-cli

ENV NODE_ENV=production
ENV PORT=9000

EXPOSE 9000

# Sử dụng full path đến medusa
CMD ["sh", "-c", "/usr/local/bin/medusa migrate && /usr/local/bin/medusa start"]