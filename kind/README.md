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

## Configure Istio
```shell
openssl req -x509 -newkey rsa:4096 -keyout ca.key -out ca.crt -days 365 -nodes -subj "/CN=RootCA"

openssl req -newkey rsa:4096 -keyout istio-ingressgateway.key -out istio-ingressgateway.csr -nodes -subj "/CN=istio-ingressgateway"
openssl x509 -req -in istio-ingressgateway.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out istio-ingressgateway.crt -days 365

kubectl create -n istio-system secret tls istio-ingressgateway-certs --key istio-ingressgateway.key --cert istio-ingressgateway.crt
kubectl create -n istio-system secret generic ca-cert --from-file=ca.crt=ca.crt
```
