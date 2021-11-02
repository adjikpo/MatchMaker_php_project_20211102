# Date : 02/10/2021
# Edited by Arthur Djikpo

CONSOLE=bin/console
DC=docker-compose
HAS_DOCKER:=$(shell command -v $(DC) 2> /dev/null)

ifdef HAS_DOCKER
	ifdef PHP_ENV
		EXECROOT=$(DC) exec -e PHP_ENV=$(PHP_ENV) php
		EXEC=$(DC) exec -e PHP_ENV=$(PHP_ENV) php
	else
		EXECROOT=$(DC) exec php
		EXEC=$(DC) exec php
	endif
else
	EXECROOT=
	EXEC=
endif

.DEFAULT_GOAL := help

.PHONY: help ## Generate list of targets with descriptions
help:
		@grep '##' Makefile \
		| grep -v 'grep\|sed' \
		| sed 's/^\.PHONY: \(.*\) ##[\s|\S]*\(.*\)/\1:\2/' \
		| sed 's/\(^##\)//' \
		| sed 's/\(##\)/\t/' \
		| expand -t14

##
## Project setup & day to day shortcuts
##---------------------------------------------------------------------------

# ENVIRONMENTS

.PHONY: env ## Init
env:
	$(RUN) cp .env.example .env
	echo "Please fill environment files, then use make setup"

# CONTAINERS

.PHONY: php ## Go into php container
php:
	$(DC) exec php bash

.PHONY: nginx ## Go into nginx container
nginx:
	$(DC) exec nginx bash

.PHONY: stop ## Stop the project
stop:
	$(DC) down

.PHONY: restart ## Stop the project
restart:
	$(DC) down
	make setup

# START PROJECTS
.PHONY: setup ## Run the project for local dev
setup:
	$(DC) pull || true
	$(DC) build
	$(DC) up -d
