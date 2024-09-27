FROM ubuntu:22.04

ENV ISPC_VERSION=v1.24.0
ENV ISPC_URL=https://github.com/ispc/ispc/releases/download/${ISPC_VERSION}/ispc-${ISPC_VERSION}-linux.tar.gz
ENV ISPC_DIR=/opt/ispc

WORKDIR /workspace

RUN set -ex \
	&& apt-get update \ 
	&& apt-get install -y wget tar \
	&& apt-get install -y build-essential \
	&& apt-get install -y cmake \
	&& apt-get install -y git \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/list/*

RUN mkdir -p ${ISPC_DIR} \
	&& cd ${ISPC_DIR} \
	&& wget -O - ${ISPC_URL} | tar -xz --strip-components=1

ENV PATH=${ISPC_DIR}/bin:${PATH}
