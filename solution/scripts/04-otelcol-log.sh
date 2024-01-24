#! /bin/bash

kubectl logs -l app=opentelemetry -n opentelemetry --follow