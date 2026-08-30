# ---------- build ----------
FROM debian:bookworm-slim AS builder

ARG HUGO_VERSION=0.165.0
ARG HUGO_BASEURL=https://julestristan.fr/

ADD https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_linux-amd64.tar.gz /tmp/hugo.tar.gz
RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates libstdc++6 \
    && rm -rf /var/lib/apt/lists/* \
    && tar -xzf /tmp/hugo.tar.gz -C /usr/local/bin hugo \
    && rm /tmp/hugo.tar.gz \
    && hugo version

WORKDIR /src
COPY . .
RUN hugo --minify --gc --baseURL "${HUGO_BASEURL}" --destination /public

# ---------- dev (hugo server, live reload) ----------
FROM builder AS dev
EXPOSE 1313
CMD ["hugo", "server", "--bind", "0.0.0.0", "--baseURL", "http://localhost:1313", "--appendPort=false", "--disableFastRender", "-D"]

# ---------- serve ----------
FROM nginx:1.27-alpine

RUN rm -f /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/conf.d/site.conf
COPY --from=builder /public /usr/share/nginx/html

EXPOSE 80
