# ==========================================
# Dockerfile - Frontend (Next.js 16 Production)
# ==========================================
FROM node:20-alpine AS builder

WORKDIR /app

# Instalar dependencias
COPY package*.json ./
COPY prisma.config.ts ./
COPY prisma ./prisma/
RUN npm ci

# Copiar código fuente y compilar
COPY . .
ENV NEXT_TELEMETRY_DISABLED=1
ENV NODE_ENV=production
RUN npx prisma generate
RUN npm run build

# Imagen de producción ligera
FROM node:20-alpine AS runner
WORKDIR /app

ENV NODE_ENV=production
ENV PORT=5005
ENV TZ=America/Guayaquil

# Instalar tzdata para zona horaria exacta
RUN apk add --no-cache tzdata

COPY --from=builder /app/package*.json ./
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public
COPY --from=builder /app/prisma ./prisma
COPY --from=builder /app/src/generated ./src/generated

EXPOSE 5005

CMD ["npm", "start"]
