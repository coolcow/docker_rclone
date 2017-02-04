# https://gist.github.com/coolcow/213653bef387855349593dcd16923637

NAMESPACE = farmcoolcow
NAME = rclone
INSTANCE = test
DEPENDENCIES = alpine farmcoolcow/entrypoints
VERSION ?= latest

# ---

IMAGE_NAME = $(NAMESPACE)/$(NAME)

# ---

default: update-dependencies build

# ---

update-dependencies:
	@for dependency in $(DEPENDENCIES); do \
	  docker pull $$dependency; \
	done

# ---

build:
	@docker build -t $(IMAGE_NAME):$(VERSION) \
	  --build-arg VCS_REF=`git rev-parse --short HEAD` \
	  --build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
      --build-arg IMAGE_NAME=$(IMAGE_NAME) \
	  --build-arg VERSION=$(VERSION) \
      .

# ---

inspect:
	@docker inspect $(IMAGE_NAME):$(VERSION)

# ---

run:
	@docker run --rm $(IMAGE_NAME):$(VERSION) $(ENVIRONMENTS) $(VOLUMES)

# ---

start:
	@docker run -d --name $(NAME)-$(INSTANCE) $(ENVIRONMENTS) $(VOLUMES) $(IMAGE_NAME):$(VERSION)

# ---

stop:
	@docker rm -f $(NAME)-$(INSTANCE)

# ---

exec:
	docker exec -it $(NAME)-$(INSTANCE) /bin/sh

# ---

shell:
	@docker run --rm -it $(IMAGE_NAME):$(VERSION) /bin/sh

# ---

release:
	@docker push $(IMAGE_NAME):$(VERSION) 
