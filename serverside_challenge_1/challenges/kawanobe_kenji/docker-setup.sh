#!/usr/bin/env bash
docker-compose exec web bin/rails db:create
docker-compose exec web bin/rails db:migrate
docker-compose exec web bin/rails provider:import
docker-compose exec web bin/rails plan:import
docker-compose exec web bin/rails basic_charge:import
docker-compose exec web bin/rails commodity_charge:import