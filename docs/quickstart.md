# Quickstart

## Pre-requisites

To get started quickly, it is recommended that you run this in a GitHub Codespace by clicking on "Use this template" and selecting the "Open in a codespace" from the dropdown in the main repo page.

Otherwise, you will need to have the following:

1. [Docker](https://docs.docker.com/get-docker/) - 24.0.x or greater
2. [KinD](https://kind.sigs.k8s.io/docs/user/quick-start/#installing-with-a-package-manager) - v0.20.x or greater
3. [kubectl](https://kubernetes.io/docs/tasks/tools/#kubectl) - 1.27.x or greater
4. [Python](https://www.python.org/downloads/) - 3.11 or greater

## PART 1

```bash
docker compose -f docker-compose-minimal.yml --env-file .env.uninstrumented build
docker compose -f docker-compose-minimal.yml --env-file .env.uninstrumented up
```

## Shareable code

Set up GH codespace. Ref [here](https://medium.com/@armamini/kubernetes-on-github-codespaces-3851163411f3).

Need to make sure that source GH repo is a [template repo](https://docs.github.com/en/repositories/creating-and-managing-repositories/creating-a-template-repository). There's a `Template Repository` checkbox in the repo settings page, just under the repo name.



```bash
# Install KinD
[ $(uname -m) = x86_64 ] && curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.20.0/kind-linux-amd64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind
kind --version

# Create KinD cluster
kind create cluster --name otel-python-lab
```

## PART 2

### Installation

1. Create KinD Cluster

    ```bash
    kind create cluster --name otel-python-lab
    ```

2. Install the OTel Operator

    > **🚨 NOTE:** [cert-manager](https://cert-manager.io) is a pre-requisite, so it needs to be installed first.

    ```bash
    # Install cert-manager
    kubectl --context kind-otel-python-lab apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.10.0/cert-manager.yaml

    # Install OTel Operator
    kubectl --context kind-otel-python-lab apply -f https://github.com/open-telemetry/opentelemetry-operator/releases/download/v0.81.0/opentelemetry-operator.yaml
    ```

3. Verify installation

    Check custom resource creation:

    ```bash
    kubectl --context kind-otel-python-lab get crds
    ```

    Sample output:

    ```
    NAME                                       CREATED AT
    certificaterequests.cert-manager.io        2023-07-25T14:44:24Z
    certificates.cert-manager.io               2023-07-25T14:44:24Z
    challenges.acme.cert-manager.io            2023-07-25T14:44:24Z
    clusterissuers.cert-manager.io             2023-07-25T14:44:24Z
    instrumentations.opentelemetry.io          2023-07-25T14:46:00Z
    issuers.cert-manager.io                    2023-07-25T14:44:24Z
    opentelemetrycollectors.opentelemetry.io   2023-07-25T14:46:00Z
    orders.acme.cert-manager.io                2023-07-25T14:44:24Z
    ```

    Make sure that cert-manager pods have started up:

    ```bash
    kubectl --context kind-otel-python-lab get pods -n cert-manager
    ```

    Sample output:

    ```
    NAME                                       READY   STATUS    RESTARTS   AGE
    cert-manager-7f6665fd8c-gp8vl              1/1     Running   0          9m32s
    cert-manager-cainjector-666564dc88-crzr9   1/1     Running   0          9m32s
    cert-manager-webhook-fd94896cd-d6s5v       1/1     Running   0          9m32s
    ```

    Make sure that OTel Operator pods have started up:

    ```bash
    kubectl --context kind-otel-python-lab get pods -n opentelemetry-operator-system
    ```

    Sample output:

    ```
    NAME                                                         READY   STATUS    RESTARTS   AGE
    opentelemetry-operator-controller-manager-7dd6b7c9c9-pxwzg   2/2     Running   0          9m11s
    ```

4. Deploy sample app

    Load Python Docker images locally in KinD. Reference [here](https://iximiuz.com/en/posts/kubernetes-kind-load-docker-image/).

    ```bash
    kind load docker-image otel-python-lab:0.1.0-py-otel-server -n otel-python-lab

    kind load docker-image otel-python-lab:0.1.0-py-otel-client -n otel-python-lab

    kind load docker-image otel-python-lab-instrumented:0.1.0-py-otel-server -n otel-python-lab

    kind load docker-image otel-python-lab-instrumented:0.1.0-py-otel-client -n otel-python-lab

    ```

    Deploy the resources

    ```bash
    kubectl --context kind-otel-python-lab apply -f src/resources/00-namespaces.yml 
    kubectl --context kind-otel-python-lab apply -f src/resources/01-jaeger.yml 
    kubectl --context kind-otel-python-lab apply -f src/resources/02-otel-collector.yml 
    kubectl --context kind-otel-python-lab apply -f src/resources/03-python-instrumentation.yml
    kubectl --context kind-otel-python-lab apply -f src/resources/04-python-client.yml
    kubectl --context kind-otel-python-lab apply -f src/resources/05-python-server.yml
    ```

5. Port-forwarding

    Open a new terminal window for each port-forward:

    ```bash
    kubectl --context kind-otel-python-lab port-forward svc/jaeger 16686:16686 -n opentelemetry

    # Only required if you want to test the server separately
    kubectl --context kind-otel-python-lab port-forward svc/py-otel-server-svc 8082:8082 -n application
    ```

6. Logs

    Run each command in a new browser window:

    ```bash
    # Server logs
    kubectl --context kind-otel-python-lab logs --selector=app=py-otel-server --container py-otel-server -n application --follow

    # Client logs
    kubectl --context kind-otel-python-lab logs --selector=app=py-otel-client --container py-otel-client -n application --follow

    # Collector logs
    kubectl --context kind-otel-python-lab logs -l app=opentelemetry -n opentelemetry --follow
    ```


7. Nukify

    Nukify `opentelemetry` and `application` namespaces

    ```bash
    kubectl kubectl --context kind-otel-python-lab logs --selector=app=py-otel-server --container py-otel-server -n application --followdelete ns opentelemetry application
    ```

    Nukify KinD cluster

    ```bash
    kind delete clusters otel-python-lab
    ```

## Debugging Auto-Instrumentation

```
# Check auto-instrumentation deployment
kubectl describe otelinst -n application

# Check events log
kubectl get events -n application

# Check operator logs
kubectl logs -l app.kubernetes.io/name=opentelemetry-operator --container manager -n opentelemetry-operator-system --follow

# Describe deployment to make sure that there's an auto-instrumentation container

# Check app logs

# Check init-containers for app. There should be a container called opentelemetry-auto-instrumentation
```
