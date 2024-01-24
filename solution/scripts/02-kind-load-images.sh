#! /bin/bash

kind load docker-image otel-python-lab:0.1.0-py-otel-server -n otel-python-lab

kind load docker-image otel-python-lab:0.1.0-py-otel-client -n otel-python-lab
