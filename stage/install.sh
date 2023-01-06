aws eks update-kubeconfig --region ap-northeast-2 --name test-cluster

# prometheus 설치
kubectl apply --server-side -f manifests/setup

kubectl wait \
        --for condition=Established \
        --all CustomResourceDefinition \
        --namespace=monitoring

kubectl apply -f manifests/
 
# istio 설치 /stage/eks/addons/istio-1.16.1
export PATH="$PATH:/Users/kmov/Documents/k8s-cluster-terraform/stage/eks/addons/istio-1.16.1/bin"
istioctl operator init
kubectl apply -f istio-demo.yaml

kubectl apply -f samples/addons/kiali.yaml 
kubectl apply -f samples/addons/jaeger.yaml 

kubectl create ns msa
kubectl label ns msa istio-injection=enabled
kubectl get ns msa --show-labels

# kiali - prometheus 연동
kubectl apply -f prometheus-rbac.yaml
kubectl apply -f prometheus-operator.yaml


kubectl edit cm -n istio-system kiali  
##################################################
    external_services:
      custom_dashboards:
        enabled: true
      istio:
        root_namespace: istio-system
      prometheus:
        url: "http://prometheus-k8s.monitoring:9090/"
      grafana:
        enabled: true
        in_cluster_url: "http://grafana.monitoring:3000/"
##################################################

# kiali pod 재실행

kubectl apply -f samples/bookinfo/platform/kube/bookinfo.yaml -n msa

# lb controller /stage/eks/lb-controller
terraform apply

kubectl edit svc istio-ingressgateway -n istio-system
# annotaion에  service.beta.kubernetes.io/aws-load-balancer-type: "nlb" 추가

# ingress gateway 실행 /stage/eks/addons/istio-1.16.1
kubectl apply -f samples/bookinfo/networking/bookinfo-gateway.yaml -n msa

# argo install /stage/mgmt/argo

kubectl patch svc argocd-server -n argocd -p '{"spec":{"type": "LoadBalancer"}}'

kubectl patch svc argocd-server -n argocd -p '{"metadata":{"annotations":{"service.beta.kubernetes.io/aws-load-balancer-type": "nlb"}}}'

# argocd 최초 비밀번호 조회
kubectl get secret argocd-initial-admin-secret -o yaml -n argocd
echo ${password}|base64 -d



# git filter-branch --index-filter 'git rm --cached --ignore-unmatch stage/eks/addons/istio-1.16.1/bin/istioctl' <sha1>..HEAD