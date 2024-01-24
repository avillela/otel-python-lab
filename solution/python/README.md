# Python OTel Example README

## Setup

```bash
python3 -m venv solution/python/venv
source solution/python/venv/bin/activate

pip install --upgrade pip

# Installs dependencies
pip install -r solution/python/requirements.txt
opentelemetry-bootstrap -a install
```

## Docker Compose

```bash
docker compose -f docker-compose-minimal.yml --env-file .env.uninstrumented build
docker compose -f docker-compose-minimal.yml --env-file .env.uninstrumented up
```

>**NOTE:** Use `--no-cache` to build without cached layers.

## Without Docker Compose

### Start OTel Collector

```
docker run -it --rm -p 4317:4317 -p 4318:4318 \
    -v $(pwd)/solution/otelcollector/otelcol-config.yml:/etc/otelcol-config.yml \
    --name otelcol otel/opentelemetry-collector-contrib:0.76.1  \
    "--config=/etc/otelcol-config.yml"
```

### Start the Services

Start server by opening up a new terminal window:

```
source solution/python/venv/bin/activate
opentelemetry-instrument \
    --traces_exporter console,otlp \
    --metrics_exporter console,otlp \
    --logs_exporter console \
    --service_name test-py-server \
    python solution/python/server.py
```

Start up client in a new terminal window:

```
source solution/python/venv/bin/activate
opentelemetry-instrument \
    --traces_exporter console,otlp \
    --metrics_exporter console,otlp \
    --logs_exporter console \
    --service_name test-py-client \
    python solution/python/client.py
```

