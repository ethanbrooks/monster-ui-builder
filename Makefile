PROJECT := monster-ui-builder
DOCKER_ORG := telephoneorg
DOCKER_USER := joeblackwaslike
DOCKER_IMAGE := $(DOCKER_ORG)/$(PROJECT):latest

KAZOO_CONFIGS_BRANCH ?= 4.2

.PHONY: all build-builder build clean

all: build-builder build

build-builder:
	@docker build -t $(DOCKER_IMAGE)

build:
	@docker run -it --rm \
		-v "$(PWD)/dist:/dist" \
		$(DOCKER_IMAGE)

clean:
	@rm -rf dist/*
