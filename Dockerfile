# ---------- Stage 1: Build ----------
FROM node:20-alpine AS builder

WORKDIR /app
 
# ---------- Stage 2 ----------
FROM node:20-alpine

WORKDIR /app

ENV NODE_ENV=production

COPY --from=builder /app/package*.json ./
RUN npm ci --omit=dev

COPY --from=builder /app/dist ./dist

EXPOSE 3000

CMD ["node", "dist/index.js"]# Copy dependency files first (for better caching)
COPY package*.json ./

# Install all dependencies (including devDependencies for build)
RUN npm ci

# Copy rest of the code
COPY . .

# Build application
RUN npm run build



