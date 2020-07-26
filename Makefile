default: build

REPO ?= tapassharma/kubectl
GIT_COMMIT ?= git-$(shell git rev-parse --short HEAD)
GIT_TAG = false
GIT_BRANCH ?= $(shell git rev-parse --abbrev-ref HEAD)

ifeq ($(TRAVIS),)
	ifeq ($(GIT_BRANCH), master)
		TAG = latest
	else
		TAG = $(GIT_BRANCH)
	endif
else
	ifeq ($(TRAVIS_TAG),)
		TAG = $(GIT_COMMIT)
		GIT_TAG = true
	else
		TAG = $(TRAVIS_TAG)
		GIT_TAG = true
	endif
endif

ifeq ($(TRAVIS_BRANCH),master)
	TAG = latest
	GIT_TAG = true
endif


build:
	@docker build --build-arg VCS_REF=`git rev-parse --short HEAD` \
	  --build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
	  -t $(REPO):$(TAG) .
	  
push:
	docker push $(REPO):$(TAG)

tag-push:
ifeq ($(GIT_TAG),true)
	@docker login -u="$(DOCKER_USERNAME)" -p="$(DOCKER_PASSWORD)"
	@$(MAKE) build push
endif

test:
	docker run $(REPO):$(TAG) version --client
