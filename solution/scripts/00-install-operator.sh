#! /bin/bash

# Install cert-manager
kubectl --context kind-otel-python-lab apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.10.0/cert-manager.yaml

sleep 30

# Install operator
kubectl --context kind-otel-python-lab apply -f https://github.com/open-telemetry/opentelemetry-operator/releases/download/v0.81.0/opentelemetry-operator.yaml