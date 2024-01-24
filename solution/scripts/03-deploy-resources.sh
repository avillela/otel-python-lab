#! /bin/bash

kubectl apply -f src/resources/00-namespaces.yml 
kubectl apply -f src/resources/01-jaeger.yml 
kubectl apply -f src/resources/02-otel-collector.yml 
kubectl apply -f src/resources/03-python-instrumentation.yml
kubectl apply -f src/resources/04-python-client.yml
kubectl apply -f src/resources/05-python-server.yml
