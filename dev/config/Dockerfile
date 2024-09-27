FROM ubuntu:22.04

RUN set -ex \
	&& apt update \ 
	&& apt install -y build-essential \
	&& apt install -y cmake \
	&& rm -rf /var/lib/apt/lists/* \
	&& apt autoremove -y \
	&& apt clean

RUN set -ex \
	&& apt update \
	&& apt install -y python3 python3-pip \
	&& rm -rf /var/lib/apt/lists/* \
	&& apt autoremove -y \
	&& apt clean

COPY requirements.txt .
RUN pip install --upgrade pip \
	&& pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple \
	&& pip3 install --no-cache-dir -r requirements.txt
