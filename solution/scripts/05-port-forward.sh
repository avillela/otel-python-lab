#! /bin/bash

kubectl --context kind-otel-python-lab port-forward svc/jaeger 16686:16686 -n opentelemetry