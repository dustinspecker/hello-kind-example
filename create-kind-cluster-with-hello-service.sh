#!/bin/bash
set -ex

# download kind
if [ ! -f ~/kind ]; then
  curl https://github.com/kubernetes-sigs/kind/releases/download/v0.8.1/kind-linux-amd64 \
    --location \
    --output ~/kind

  chmod +x ~/kind
fi

~/kind version


# download kubectl
if [ ! -f ~/kubectl ]; then
  curl https://storage.googleapis.com/kubernetes-release/release/v1.18.5/bin/linux/amd64/kubectl \
    --location \
    --output ~/kubectl

  chmod +x ~/kubectl
fi

~/kubectl version --client


# create cluster
if ! ~/kind get clusters | grep kind ; then
  ~/kind create cluster

  ~/kubectl wait node kind-control-plane \
    --for condition=Ready \
    --timeout 300s
fi

# create hello service and pod
if ! ~/kubectl get pod hello ; then
  ~/kubectl run hello \
    --expose \
    --image nginxdemos/hello:plain-text \
    --port 80
fi
