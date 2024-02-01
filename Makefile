ALPINE_VERSION := 3.19.1
CONTAINER_ORGANIZATION := connectical
CONTAINER_IMAGE := taskd
CONTAINER_ARCHITECTURES := linux/amd64,linux/arm/v7,linux/arm64
TAGS := -t quay.io/$(CONTAINER_ORGANIZATION)/$(CONTAINER_IMAGE):master
TAGS += -t ghcr.io/$(CONTAINER_ORGANIZATION)/$(CONTAINER_IMAGE):master
ifdef CIRCLE_TAG
	TAGS := -t quay.io/$(CONTAINER_ORGANIZATION)/$(CONTAINER_IMAGE):latest
	TAGS += -t ghcr.io/$(CONTAINER_ORGANIZATION)/$(CONTAINER_IMAGE):latest
	TAGS += -t quay.io/$(CONTAINER_ORGANIZATION)/$(CONTAINER_IMAGE):${CIRCLE_TAG}
	TAGS += -t ghcr.io/$(CONTAINER_ORGANIZATION)/$(CONTAINER_IMAGE):${CIRCLE_TAG}
endif

all: container-build

check-quay-env:
ifndef QUAY_USERNAME
	$(error QUAY_USERNAME is undefined)
endif
ifndef QUAY_PASSWORD
	$(error QUAY_PASSWORD is undefined)
endif

check-github-registry-env:
ifndef GITHUB_REGISTRY_USERNAME
	$(error GITHUB_REGISTRY_USERNAME is undefined)
endif
ifndef GITHUB_REGISTRY_PASSWORD
	$(error GITHUB_REGISTRY_PASSWORD is undefined)
endif

container-build:
	docker build -t $(CONTAINER_ORGANIZATION)/$(CONTAINER_IMAGE) --build-arg ALPINE_VERSION=$(ALPINE_VERSION) .

container-buildx:
	docker buildx build -t $(CONTAINER_ORGANIZATION)/$(CONTAINER_IMAGE) --platform $(CONTAINER_ARCHITECTURES) --build-arg ALPINE_VERSION=$(ALPINE_VERSION) .

container-buildx-push: check-quay-env check-github-registry-env
	echo "${QUAY_PASSWORD}" | docker login -u "${QUAY_USERNAME}" --password-stdin quay.io
	echo "${GITHUB_REGISTRY_PASSWORD}" | docker login -u "${GITHUB_REGISTRY_USERNAME}" --password-stdin ghcr.io
	docker buildx build $(TAGS) --platform $(CONTAINER_ARCHITECTURES) --build-arg ALPINE_VERSION=$(ALPINE_VERSION) --push .

.PHONY: all check-quay-env check-github-registry-env container-build container-buildx container-buildx-push
# vim:ft=make
