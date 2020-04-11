# -- Docker
COMPOSE              = docker-compose
COMPOSE_RUN          = $(COMPOSE) run --rm
COMPOSE_RUN_APP      = $(COMPOSE_RUN) app

# ==============================================================================
# RULES

default: help

bootstrap: ## Bootstrap nextcloud project
bootstrap: \
	build \
	install
.PHONY: bootstrap

build: ## Build the app container
	@$(COMPOSE) build nextcloud
.PHONY: build

install: ## Install Nextcloud
	@$(COMPOSE) up -d db
	@echo "Wait for database to be up and running..."
	@$(COMPOSE_RUN) dockerize -wait tcp://db:5432 -timeout 60s
	@$(COMPOSE_RUN) nextcloud-install
.phony: install

run: ## Start the development server using Docker
	@$(COMPOSE) up -d db
	@echo "Wait for database to be up and running..."
	@$(COMPOSE_RUN) dockerize -wait tcp://db:5432 -timeout 60s
	@$(COMPOSE) up -d nextcloud
.PHONY: run

stop: ## Stop the development server using Docker
	@$(COMPOSE) stop
.PHONY: stop

# -- Misc

help:
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
.PHONY: help
