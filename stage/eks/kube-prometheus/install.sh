aws eks update-kubeconfig --region ap-northeast-2 --name test-cluster
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
kubectl create ns monitoring
helm install prometheus prometheus-community/kube-prometheus-stack -f "values.yaml" --namespace monitoring
kubectl port-forward service/prometheus-grafana 3000:80 --namespace monitoring

# id는 admin
# pw는 prom-operator