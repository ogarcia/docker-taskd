DOCKER_USER := ogarcia
DOCKER_ORGANIZATION := connectical
DOCKER_IMAGE := taskd

docker-image:
	docker build -t $(DOCKER_ORGANIZATION)/$(DOCKER_IMAGE) .

docker-image-test: docker-image
	docker run --rm $(DOCKER_ORGANIZATION)/$(DOCKER_IMAGE) /usr/bin/taskd --version

ci-test:
	docker run -t -i --rm --privileged -v /run/docker.sock:/var/run/docker.sock -v $(PWD):/app -w /app alpine:latest \
		sh -c 'apk -U --no-progress upgrade && apk -U --no-progress add docker make && make docker-image-test'

.PHONY: docker-image docker-image-test ci-test
# vim:ft=make
