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
helm upgrade --install ingress-nginx ingress-nginx \
  --repo https://kubernetes.github.io/ingress-nginx \
  --namespace ingress-nginx --create-namespace \
  -f ingress-nginx-values.yaml
```

### Deploy Argocd
```shell
helm install argo-cd argo/argo-cd -n argocd --create-namespace -f argo-values.yaml --version 7.8.24

# helm upgrade argo-cd argo/argo-cd -n argocd -f argo-values.yaml
```

```shell
kubectl create secret docker-registry ghcr-secret --docker-server=ghcr.io --docker-username={USER-NAME} --docker-password={ghp_xxx} --docker-email={EMAIL-ADDRESS} -n default
```

```shell
kubectl apply -f apps/appset.yaml -n argocd
```

### Deploy Nats Cluster
```shell
helm repo add nats https://nats-io.github.io/k8s/helm/charts/
helm repo update
helm install nats nats/nats --create-namespace -f nats.yaml
```

