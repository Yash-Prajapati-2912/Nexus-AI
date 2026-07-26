# ==============================================================================
# NEXUS AI BACKEND - PRODUCTION MULTI-STAGE DOCKERFILE
# ==============================================================================
# Stage 1: Build & Compile TypeScript Code
# Stage 2: Production Runtime Environment (Slim Node.js Alpine Container)
# ==============================================================================

# ------------------------------------------------------------------------------
# Stage 1: Builder Stage
# ------------------------------------------------------------------------------
FROM node:20-alpine AS builder

WORKDIR /usr/src/app

# Install pnpm package manager globally
RUN npm install -g pnpm

# Copy package manifests to leverage Docker layer caching
COPY package.json pnpm-lock.yaml* ./

# Install all dependencies (including devDependencies required for compilation)
RUN pnpm install --frozen-lockfile || npm install

# Copy application source code & configuration
COPY tsconfig.json tsconfig.build.json nest-cli.json ./
COPY src ./src

# Build TypeScript application to dist/
RUN npm run build

# Prune devDependencies to keep production image size minimal
RUN pnpm prune --prod || npm prune --production

# ------------------------------------------------------------------------------
# Stage 2: Production Stage
# ------------------------------------------------------------------------------
FROM node:20-alpine AS production

WORKDIR /usr/src/app

# Set production node environment
ENV NODE_ENV=production

# Install wget for Docker container health check probes
RUN apk add --no-cache wget

# Create non-root node user for container security
USER node

# Copy built application artifacts and production dependencies from builder stage
COPY --chown=node:node --from=builder /usr/src/app/package.json ./
COPY --chown=node:node --from=builder /usr/src/app/node_modules ./node_modules
COPY --chown=node:node --from=builder /usr/src/app/dist ./dist

# Expose HTTP API Port
EXPOSE 3000

# Execute production server bundle
CMD ["node", "dist/main"]
