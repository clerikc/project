FROM ubuntu:24.04

# 1. Сначала обновляем пакеты и ставим wget (теперь это делаем в одном RUN!)
RUN apt-get update && apt-get install -y \
    wget \
    sudo \
    docker.io \
    curl \
    && rm -rf /var/lib/apt/lists/*

# 2. Устанавливаем kubectl (используем curl вместо первого wget для надёжности)
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
    && mv kubectl /usr/local/bin/kubectl \
    && chmod +x /usr/local/bin/kubectl

# 3. Устанавливаем Minikube
RUN curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 \
    && mv minikube-linux-amd64 /usr/local/bin/minikube \
    && chmod +x /usr/local/bin/minikube

# 4. Устанавливаем Helm
RUN curl -LO https://get.helm.sh/helm-v3.14.2-linux-amd64.tar.gz \
    && tar xzf helm-v3.14.2-linux-amd64.tar.gz -C /tmp \
    && mv /tmp/linux-amd64/helm /usr/local/bin/helm

# 5. Копируем конфиги и скрипты
COPY ./k8s-config /k8s-config
COPY ./init-cluster.sh /init-cluster.sh
RUN chmod +x /init-cluster.sh

# 6. Фиксим DNS (на всякий случай)
RUN echo "nameserver 8.8.8.8" > /etc/resolv.conf \
    && echo "nameserver 1.1.1.1" >> /etc/resolv.conf

CMD ["/init-cluster.sh"]