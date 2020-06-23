#!/bin/bash
set -ex

# download kind
if [ ! -f ~/kind ]; then
  curl https://github.com/kubernetes-sigs/kind/releases/download/v0.7.0/kind-linux-amd64 \
    --location \
    --output ~/kind

  chmod +x ~/kind
fi

~/kind version


# download kubectl
if [ ! -f ~/kubectl ]; then
  curl https://storage.googleapis.com/kubernetes-release/release/v1.17.0/bin/linux/amd64/kubectl \
    --location \
    --output ~/kubectl

  chmod +x ~/kubectl
fi

~/kubectl version --client


# create cluster
if ! ~/kind get clusters | grep kind ; then
  ~/kind create cluster
fi

# create hello service and deployment
if ! ~/kubectl get deployment hello ; then
  ~/kubectl run hello \
    --expose \
    --image nginxdemos/hello:plain-text \
    --port 80
fi
