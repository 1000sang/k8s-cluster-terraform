curl -L https://istio.io/downloadIstio | ISTIO_VERSION=1.16.1 sh -

export PATH="$PATH:/Users/kmov/Documents/tf-k8s-boilerplate/stage/eks/addons/istio-1.16.1/bin"

istioctl operator init
