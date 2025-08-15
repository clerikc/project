#!/bin/bash

# Ожидание запуска SSH сервера
sleep 5

# Настройка окружения Minikube
export MINIKUBE_HOME=/minikube
export KUBECONFIG=$MINIKUBE_HOME/.kube/config
export CHANGE_MINIKUBE_NONE_USER=true

# Очистка предыдущего кластера
minikube delete --all --purge

# Запуск Minikube с исправленными параметрами
minikube start \
  --driver=docker \
  --container-runtime=containerd \
  --force \
  --wait=all \
  --wait-timeout=10m \
  --alsologtostderr \
  --v=5 \
  --cpus=2 \
  --memory=4G \
  --disk-size=20GB \
  --extra-config=kubelet.cgroup-driver=systemd

# Применение конфигураций
kubectl apply -f /k8s-config/

echo -e "\n=== Доступ к сервисам ==="
echo "Grafana: http://localhost:30900 (admin/admin)"
echo "Приложение: http://localhost:30080"
echo "Dashboard: minikube dashboard --url"

# Бесконечное ожидание
tail -f /dev/null