NAMESPACE = farmcoolcow
NAME = rclone
VERSION ?= latest
INSTANCE = test
DEPENDENCIES = alpine farmcoolcow/alpine_entrypoint

IMAGE = $(NAMESPACE)/$(NAME):$(VERSION)

default: update-dependencies build

update-dependencies:
	for dependency in $(DEPENDENCIES); do docker pull $$dependency; done

build:
	docker build -t $(IMAGE) .

run:
	docker run --rm $(IMAGE) $(ENVIRONMENTS) $(VOLUMES)

start:
	docker run -d --name $(NAME)-$(INSTANCE) $(ENVIRONMENTS) $(VOLUMES) $(IMAGE)

stop:
	docker rm -f $(NAME)-$(INSTANCE)

exec:
	docker exec -it $(NAME)-$(INSTANCE) /bin/sh

shell:
	docker run --rm -it $(IMAGE) /bin/sh
