#! /bin/bash

# ---------------------------
# -- Kubernetes installation
# ---------------------------

# Install KinD
[ $(uname -m) = x86_64 ] && curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.20.0/kind-linux-amd64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind
kind --version

# Create KinD cluster
kind create cluster --name otel-python-lab

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
