# Stage 1: Build
FROM node:20-alpine AS builder

WORKDIR /app
COPY package.json package-lock.json ./

# Cài đặt dependencies KHÔNG bao gồm dotenv
RUN npm ci --production

COPY . .
RUN npm run build

# Stage 2: Production
FROM node:20-alpine
WORKDIR /app

COPY --from=builder /app .
COPY --from=builder /usr/local/lib/node_modules /usr/local/lib/node_modules
COPY --from=builder /usr/local/bin/medusa /usr/local/bin/medusa

# Cấu hình Environment Variables trực tiếp qua Coolify
ENV PATH="/usr/local/bin:${PATH}"

CMD ["sh", "-c", "medusa migrate && medusa start"]