default: build

DOCKER_IMAGE ?= tapassharma/kubectl
GIT_BRANCH ?= $(shell git rev-parse --abbrev-ref HEAD)

ifdef $(DOCKERTAG)
	GIT_BRANCH = $(DOCKERTAG)
endif

ifeq ($(GIT_BRANCH), master)
	DOCKER_TAG = latest
else
	DOCKER_TAG = $(GIT_BRANCH)
endif

## If travis branch is set use that
## as the docker tag
ifdef $(TRAVIS_BRANCH)
	DOCKER_TAG = $(TRAVIS_BRANCH)
endif

## if TRAVIS_TAG is not empty then we are tagging
## a release
ifneq ($(TRAVIS_TAG),) 
	DOCKER_TAG = $(TRAVIS_TAG)
endif

build:
	@docker build --build-arg VCS_REF=`git rev-parse --short HEAD` \
	  --build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
	  -t $(DOCKER_IMAGE):$(DOCKER_TAG) .
	  
push:
	docker push $(DOCKER_IMAGE):$(DOCKER_TAG)

test:
	docker run $(DOCKER_IMAGE):$(DOCKER_TAG) version --client
