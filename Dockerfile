FROM ubuntu:24.04

# Устанавливаем базовые утилиты и Docker
RUN apt-get update && apt-get install -y \
    wget \
    sudo \
    docker.io \
    && rm -rf /var/lib/apt/lists/*

# Устанавливаем kubectl (актуальная версия)
RUN wget -qO- https://dl.k8s.io/release/$(wget -qO- https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl > /usr/local/bin/kubectl \
    && chmod +x /usr/local/bin/kubectl

# Устанавливаем Minikube
RUN wget -qO- https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 > /usr/local/bin/minikube \
    && chmod +x /usr/local/bin/minikube

# Устанавливаем Helm
RUN wget -qO- https://get.helm.sh/helm-v3.14.2-linux-amd64.tar.gz | tar xz -C /tmp \
    && mv /tmp/linux-amd64/helm /usr/local/bin/helm

# Копируем конфиги и скрипты
COPY ./k8s-config /k8s-config
COPY ./init-cluster.sh /init-cluster.sh
RUN chmod +x /init-cluster.sh

# Запускаем скрипт при старте
CMD ["/init-cluster.sh"]