#!/bin/bash

DOCKER_BASE_DIR=~/standard_config/docker_config

Dockerfile_maker() {
    echo "Initializing..."
    touch Dockerfile
    echo "FROM ubuntu:22.04" > Dockerfile
    echo "" >> Dockerfile
    echo "WORKDIR /workspace" >> Dockerfile
    echo "" >> Dockerfile

    echo """
    Input image layers you want (split by , or space)
    1 -> basic tools (include: git)
    2 -> python
    3 -> cpp essential
    4 -> rust
    """
    read -r choices
    local -a choices_a=(${choices//,/ })

    for c in "${choices_a[@]}"; 
	do
        case $c in
            1)
                cat <<'EOF' >> Dockerfile
RUN set -ex \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y git \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
EOF
                echo "" >> Dockerfile
                ;;
            2)
                cat <<'EOF' >> Dockerfile
RUN set -ex \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y python3 python3-pip \
    && pip3 install --upgrade pip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
EOF
                echo "" >> Dockerfile

                read -rp "Do you have requirements.txt for python? (y|N) " require
                if [[ $require == "y" ]]; 
				then
                    cat <<'EOF' >> Dockerfile
COPY requirements.txt .
RUN pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple \
    && pip3 install --no-cache-dir -r requirements.txt
EOF
                    echo "" >> Dockerfile
                fi
                ;;
            3)
                cat <<'EOF' >> Dockerfile
RUN set -ex \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y build-essential cmake \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
EOF
                echo "" >> Dockerfile
                ;;
            4)
                cat <<'EOF' >> Dockerfile
RUN set -ex \
    && apt-get update \
    && curl -sSf https://sh.rustup.rs | sh -s -- -y \
    && rustup update \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
EOF
                echo "" >> Dockerfile
                ;;
            *)
                echo "Invalid choice."
                ;;
        esac
    done
}

docker_compose_maker() {
    local image_name=$1
    cd .. && mkdir workspace && cd config
    touch docker-compose.yml
    cat <<EOF > docker-compose.yml
version: '3'
services:
  ${image_name}_ubuntu22:
    build:
      context: .
      dockerfile: Dockerfile
    container_name: ${image_name}_ubuntu22
    init: true
    ports:
      - "8080:80"
    network_mode: host
    ipc: host
    restart: always
    privileged: true
    tty: true
    shm_size: 268M
    volumes:
      - ../workspace:/workspace
EOF
}

docker_builder() {
    local dir_name=$1
    cd ~
    if [[ -d "$dir_name" ]]; 
	then
        echo "$dir_name is already exists. Cover it? (y|N)"
        while true; 
		do
            read -rp "Enter your choice: " cover_or_not
            if [[ $cover_or_not == "y" ]]; 
			then
                rm -r "$dir_name"
                mkdir -p "$dir_name" && cd "$dir_name"
                mkdir config && cd config
                Dockerfile_maker
                docker_compose_maker "$dir_name"
                echo "Build finished"
                break
            elif [[ $cover_or_not == "N" ]]; then
                echo "Script exits"
                exit 0
            else
                echo "Illegal input, try again."
            fi
        done
    else
        mkdir -p "$dir_name" && cd "$dir_name"
        mkdir config && cd config
        Dockerfile_maker
        docker_compose_maker "$dir_name"
        echo "Build finished"
    fi
}

while true; 
do
    echo """
    Input your requirements:
    1 -> Copy Docker files.
    """

    read -rp "Enter your choice: " number
    case $number in
        1)
            read -rp "Enter the name of your new project (new directory in ~ dir): " dir_name
            docker_builder "$dir_name"
            break
            ;;
        *)
            echo "Illegal input, enter valid value."
            ;;
    esac
done
