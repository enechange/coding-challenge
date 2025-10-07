#!/bin/bash
set -ex

docker compose build
docker compose run --rm web rails db:setup
docker compose up -d
