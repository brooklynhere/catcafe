FROM node:22-alpine AS tailwind

WORKDIR /src
COPY package.json package-lock.json ./
RUN npm ci
COPY assets/css/tailwind.css ./assets/css/tailwind.css
COPY layouts ./layouts
RUN npm run build:css

FROM hugomods/hugo:exts AS builder

WORKDIR /src
COPY . .
COPY --from=tailwind /src/static/css/tailwind.css ./static/css/tailwind.css

RUN hugo --minify

FROM caddy:2-alpine

COPY Caddyfile /etc/caddy/Caddyfile

COPY --from=builder /src/public /usr/share/caddy