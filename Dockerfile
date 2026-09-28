FROM hugomods/hugo:exts AS builder

WORKDIR /src
COPY . .

RUN hugo --minify

FROM caddy:2-alpine

COPY Caddyfile /etc/caddy/Caddyfile

COPY --from=builder /src/public /usr/share/caddy