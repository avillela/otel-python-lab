#! /bin/bash

# ---------------------------
# -- Kubernetes installation
# ---------------------------

# Install KinD
[ $(uname -m) = x86_64 ] && curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.24.0/kind-linux-amd64
[ $(uname -m) = aarch64 ] && curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.24.0/kind-linux-arm64

chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind
kind --version

# Create KinD cluster
kind create cluster --name otel-python-lab

# Install kubectl
[ $(uname -m) = x86_64 ] && curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
[ $(uname -m) = aarch64 ] && curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/arm64/kubectl"

chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl

# ---------------------------
# -- Install VSCode extensions
# ---------------------------

code --install-extension ms-python.python
code --install-extension ms-python.pylint
code --install-extension ms-azuretools.vscode-docker


# ---------------------------
# -- Python venv setup
# ---------------------------

python -m venv src/python/venv
source src/python/venv/bin/activate

pip install --upgrade pip
