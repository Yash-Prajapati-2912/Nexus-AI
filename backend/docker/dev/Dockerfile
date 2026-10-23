FROM node:20-alpine

WORKDIR /usr/src/app

RUN npm install -g pnpm

COPY package.json pnpm-lock.yaml ./

RUN pnpm install

COPY . .

EXPOSE 3000
EXPOSE 9229

# Auto-sync dependencies on container startup & start NestJS dev watch mode
CMD ["sh", "-c", "pnpm install && pnpm run start:dev"]
