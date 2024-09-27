FROM ubuntu:22.04

WORKDIR /workspace

RUN set -ex \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y git \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN set -ex \
    && apt-get update \
    && curl -sSf https://sh.rustup.rs | sh -s -- -y \
    && rustup update \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

