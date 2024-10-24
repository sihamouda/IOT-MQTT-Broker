# Executables: local only
DOCKER_COMP = docker compose -f docker-compose.mosquitto.yaml
DOCKER_COMP_EXEC = $(DOCKER_COMP) exec mosquitto

# Misc
.DEFAULT_GOAL = help

help: ## Outputs this help screen
	@grep -E '(^[a-zA-Z0-9_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}{printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'

alias: ## Displays all alias of the package manager
	$(DOCKER_COMP_EXEC) npm run

## —— Docker 🐳 ————————————————————————————————————————————————————————————————
build: ## Builds the Node image
	BUILDKIT_PROGRESS=plain $(DOCKER_COMP) build --no-cache

up: ## Starts the docker hub
	$(DOCKER_COMP) up -d

down: ## Stops the docker hub
	$(DOCKER_COMP) down --remove-orphans

remove: ## Remove the docker hub
	$(DOCKER_COMP) down --remove-orphans -v

restart: ## Restarts the docker hub
	$(DOCKER_COMP) restart

sh: ## Connects to the application container
	$(DOCKER_COMP_EXEC) sh

logs: ## Displays the logs of the application container
	$(DOCKER_COMP) logs -f mosquitto

## —— Project 🐝 ———————————————————————————————————————————————————————————————
setup-project: ## Initializes configuration
	make build

## —— Dev ⚙️ ———————————————————————————————————————————————————————————————
dev: ## Destroy server and rebuild
	make remove	
	make build
	make up

venv: ## Creates venv
	(cd clients && python3 -m venv venv)

sub: ## run subscriber client snippet
	(cd clients && python3 subscriber.py)

pub: ## run subscriber client snippet
	(cd clients && python3 publisher.py)