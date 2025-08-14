#!/bin/bash

while ! docker ps > /dev/null 2>&1; do
    echo "Waiting for docker daemon..."
    sleep 1
done

# Удаляем старый кластер (если был)
minikube delete

# Запускаем Minikube с Docker-драйвером
minikube start --driver=docker --force
eval $(minikube docker-env)

# Настраиваем доступ к Kubernetes API
kubectl config use-context minikube

# Устанавливаем Prometheus + Grafana через Helm
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm upgrade --install monitoring prometheus-community/kube-prometheus-stack \
  -f /k8s-config/prometheus-values.yaml \
  --set grafana.service.type=NodePort \
  --set grafana.service.nodePort=30900

# Деплоим приложение
kubectl apply -f /k8s-config/webapp-deployment.yaml

# Ждём запуска подов
echo "Ожидаем запуска Pods..."
kubectl wait --for=condition=Ready pods --all --timeout=120s

# Выводим информацию для доступа
echo "=== Доступ к сервисам ==="
echo "Grafana: http://$(minikube ip):30900 (логин: admin, пароль: admin)"
echo "Приложение: http://$(minikube ip):30080"
echo "Dashboard: $(minikube dashboard --url)"

# Бесконечное ожидание
sleep infinity