# syntax=docker/dockerfile:1.19.0
FROM debian:forky-slim

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ca-certificates \
    clang-19 \
    binaryen \
    clang-19 \
    make \
    rustup

# Based on https://github.com/andizimmerer/docker-rust-wasm/blob/master/Dockerfile
RUN rustup update && \
    rustup install 1.91.1 && \
    rustup default 1.91.1 && \
    rustup target add wasm32-unknown-unknown --toolchain 1.91.1

WORKDIR "/app"
COPY --exclude=Dockerfile . "/app"
RUN make

FROM nginx:1.29

COPY --from=0 --chown=nginx:nginx "/app/index.html" "/app/main.js" "/app/doom.wasm" "/usr/share/nginx/html/sctv"
