.DEFAULT_GOAL := help

.PHONY: up
up:
	docker compose -f ./docker-compose.yml up -d

.PHONY: down
down:
	docker compose -f ./docker-compose.yml down --remove-orphans

.PHONY: reset
reset: down up

.PHONY: log
log:
	docker compose -f ./docker-compose.yml logs -f || true

.PHONY: login
login:
	docker compose -f ./docker-compose.yml exec -u root web /bin/bash

.PHONY: help
help:
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@echo "  up: Start docker container"
	@echo "  down: Stop docker container"
	@echo "  reset: Restart docker container"
	@echo "  log: Show docker container log"
	@echo "  login: Login docker container"
	@echo "  help: Show this help message"
