FROM ubuntu:24.04

# 1. Установка всех зависимостей в одном слое
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    docker.io \
    socat \
    conntrack \
    && rm -rf /var/lib/apt/lists/*

# 2. Добавляем пользователя root в группу docker (без создания группы)
RUN usermod -aG docker root

# 3. Установка kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
    && install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl \
    && rm kubectl

# 4. Установка Minikube
RUN curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 \
    && install -o root -g root -m 0755 minikube-linux-amd64 /usr/local/bin/minikube \
    && rm minikube-linux-amd64

# 5. Установка Helm
RUN curl -LO https://get.helm.sh/helm-v3.14.2-linux-amd64.tar.gz \
    && tar xzf helm-v3.14.2-linux-amd64.tar.gz -C /tmp \
    && install -o root -g root -m 0755 /tmp/linux-amd64/helm /usr/local/bin/helm \
    && rm -rf /tmp/linux-amd64 helm-v3.14.2-linux-amd64.tar.gz

# 6. Копирование конфигов и скриптов
COPY ./k8s-config /k8s-config
COPY ./init-cluster.sh /init-cluster.sh
RUN chmod 755 /init-cluster.sh

# 7. Рабочая директория
WORKDIR /k8s-config

CMD ["/init-cluster.sh"]