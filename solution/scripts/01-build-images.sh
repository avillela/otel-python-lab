#! /bin/bash

docker compose -f docker-compose-minimal.yml --env-file .env.uninstrumented build