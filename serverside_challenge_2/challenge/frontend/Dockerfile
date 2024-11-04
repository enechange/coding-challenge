FROM node:23-slim

WORKDIR /app

COPY package.json pnpm-lock.yaml* ./
RUN \
  if [ -f pnpm-lock.yaml ]; then corepack enable pnpm && pnpm i; \
  else echo "Lockfile not found." && exit 1; \
  fi

COPY src ./src
COPY public ./public
COPY .env.local .
COPY index.html .
COPY eslint.config.js .
COPY tsconfig.json .
COPY tsconfig.app.json .
COPY tsconfig.node.json .
COPY vite.config.ts .

CMD \
  if [ -f pnpm-lock.yaml ]; then pnpm dev --host; \
  else echo "Lockfile not found." && exit 1; \
  fi