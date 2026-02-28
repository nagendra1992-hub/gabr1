# ---------- Stage 1: Build ----------
FROM node:20-alpine AS builder

WORKDIR /app
 
# Copy dependency files first (for better caching)
COPY package*.json ./

# Install all dependencies (including devDependencies for build)
RUN npm ci

# Copy rest of the code
COPY . .

# Build application
RUN npm run build


# ---------- Stage 2: Production ----------
FROM node:20-alpine

WORKDIR /app

# Set environment
ENV NODE_ENV=production
ENV PORT=3000

# Copy only required files from builder
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/dist ./dist

# Expose application port
EXPOSE 3000

# Start application properly
CMD ["node", "dist/index.js"]
