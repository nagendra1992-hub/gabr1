# ---------- Stage 1: Build ----------
FROM node:20-alpine AS builder

WORKDIR /app

# Copy dependency files first for better caching
COPY package*.json ./

# Install all dependencies
RUN npm ci

# Copy the rest of the application code
COPY . .

# Build the application (generates the /dist folder)
RUN npm run build

# ---------- Stage 2: Production ----------
# Use Nginx to serve the static files for production
FROM nginx:stable-alpine

# Copy the built static files from the builder stage to Nginx's serve directory
COPY --from=builder /app/dist /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
