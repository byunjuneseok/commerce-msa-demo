# KIND

## Install Prerequisites
```shell
# Install kind
brew install kind

# Install cloud provider for kind
go install sigs.k8s.io/cloud-provider-kind@latest
```
## Configure Kind Development Environment

### Create a Kind Cluster
```shell
kind create cluster --config=cluster.yaml

# Check if the cluster is up and running
kubectl get nodes
```

### Install Ingress NGINX
```shell
kubectl apply -f deploy-ingress-nginx.yaml 

kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=90s
```

### Install MetalLB

```shell
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.14.9/config/manifests/metallb-native.yaml
kubectl wait --namespace metallb-system \
                --for=condition=ready pod \
                --selector=app=metallb \
                --timeout=90s
```

Then configure MetalLB IP Pool.
```shell
# Check the IP range of the kind cluster
docker network inspect -f '{{.IPAM.Config}}' kind 

# Add IPAddressPool
kubectl apply -f metallb-ip-pool.yaml
```

### Deploy Argocd
```shell
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

And Change the argocd-server service type to LoadBalancer
```shell
kubectl patch svc argocd-server -n argocd --type='json' -p '[{"op": "replace", "path": "/spec/type", "value": "LoadBalancer"}]'
```

```shell
echo "kubectl create secret docker-registry ghcr-secret --docker-server=ghcr.io --docker-username={USER-NAME} --docker-password={ghp_xxx} --docker-email={EMAIL-ADDRESS} -n default"
```