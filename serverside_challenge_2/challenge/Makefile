DC = docker compose
DC_TEST = $(DC) -f compose.test.yml

.PHONY: build up down api-bash init test-build test-up test-down test-api-bash

build:
	$(DC) build
up:
	$(DC) up -d

down:
	$(DC) down

api-bash:
	$(DC) exec api bash

init:
	$(DC) exec api rails db:create
	$(DC) exec api rails db:migrate
	$(DC) exec api rails db:seed

test-build:
	$(DC_TEST) build

test-up:
	$(DC_TEST) up -d

test-down:
	$(DC_TEST) down

test-api-bash:
	$(DC_TEST) exec test-api bash
