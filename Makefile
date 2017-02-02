# https://gist.github.com/coolcow/213653bef387855349593dcd16923637

NAMESPACE = farmcoolcow
NAME = rclone
INSTANCE = test
DEPENDENCIES = alpine farmcoolcow/alpine_entrypoint
VERSION ?= latest

# ---

IMAGE = $(NAMESPACE)/$(NAME):$(VERSION)

# ---

default: update-dependencies build

# ---

update-dependencies:
	@for dependency in $(DEPENDENCIES); do \
	  docker pull $$dependency; \
	done

# ---

build:
	@docker build -t $(IMAGE) \
	  --build-arg VCS_REF=`git rev-parse --short HEAD` \
	  --build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
	  --build-arg VERSION=$(VERSION) \
      .

# ---

inspect:
	@docker inspect $(IMAGE)

# ---

run:
	@docker run --rm $(IMAGE) $(ENVIRONMENTS) $(VOLUMES)

# ---

start:
	@docker run -d --name $(NAME)-$(INSTANCE) $(ENVIRONMENTS) $(VOLUMES) $(IMAGE)

# ---

stop:
	@docker rm -f $(NAME)-$(INSTANCE)

# ---

exec:
	docker exec -it $(NAME)-$(INSTANCE) /bin/sh

# ---

shell:
	@docker run --rm -it $(IMAGE) /bin/sh

# ---

release:
	@docker push $(IMAGE) 
