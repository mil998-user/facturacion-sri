# ==========================================
# Dockerfile - Backend (Express REST API)
# ==========================================
FROM node:20-alpine AS builder

WORKDIR /app

# Instalar dependencias
COPY backend/package*.json ./
COPY backend/prisma ./prisma/
RUN npm ci

# Copiar código fuente y compilar TypeScript
COPY backend/ .
RUN npx prisma generate
RUN npm run build

# Imagen de producción ligera
FROM node:20-alpine AS runner
WORKDIR /app

ENV NODE_ENV=production
ENV PORT=8005
ENV TZ=America/Guayaquil

# Instalar tzdata para zona horaria exacta
RUN apk add --no-cache tzdata

COPY --from=builder /app/package*.json ./
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/prisma ./prisma

EXPOSE 8005

CMD ["node", "dist/index.js"]
