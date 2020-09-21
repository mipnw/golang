SHELL := /bin/bash
IMAGE_NAME = mipnw/golang
GO_VERSION := 1.15
BASE_OS := alpine3.12
TAG ?= $(GO_VERSION)-$(BASE_OS)
THIS_DIR = $(shell pwd)

DOCKER_ARGS :=                --env LOCAL_USER_ID=$(shell id -u)
DOCKER_ARGS := $(DOCKER_ARGS) --env LOCAL_GROUP_ID=$(shell id -g)
DOCKER_ARGS := $(DOCKER_ARGS) --env ROOT=$(ROOT)
DOCKER_ARGS := $(DOCKER_ARGS) --workdir /$(IMAGE_NAME)
DOCKER_ARGS := $(DOCKER_ARGS) --volume $(THIS_DIR)/projects:/$(IMAGE_NAME)
ifdef DOCKER_USER_PATH
DOCKER_ARGS := $(DOCKER_ARGS) --volume $(DOCKER_USER_PATH):/mnt/appuser:ro
endif

.PHONY: help
help:
	@echo 'Usage: make [target] [options]'
	@echo 'Build and use the Alpine base'
	@echo
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'

ifndef VERBOSE
.SILENT:
endif

.dockerimage.$(TAG): $(GO_VERSION)/$(BASE_OS)/Dockerfile
	docker build \
		--force-rm \
		-f $(GO_VERSION)/$(BASE_OS)/Dockerfile \
		-t $(IMAGE_NAME):$(TAG) \
		$(THIS_DIR)
	touch .dockerimage.$(TAG)
build: .dockerimage.$(TAG) ## builds the docker image

.PHONY: shell
shell: .dockerimage.$(TAG) ## shells into the docker container
	docker run --rm -it \
		--hostname devbox \
		$(DOCKER_ARGS) \
		$(IMAGE_NAME):$(TAG) \
		/bin/bash

.PHONY: clean
clean: ## cleans your host of development artifacts
	-docker image rm -f $(IMAGE_NAME):$(TAG) &> /dev/null
	-rm .dockerimage.$(TAG) &> /dev/null