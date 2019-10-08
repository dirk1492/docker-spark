.PHONY: build

VERSION=2.4.4
TAG = $(VERSION)
REPO = dil001/spark

build:
	docker build -t $(REPO) .
	docker tag $(REPO) $(REPO):$(TAG)

push:
	docker push $(REPO)
	docker push $(REPO):$(TAG)

clean:
	docker rmi $(REPO)
	docker rmi $(REPO):$(TAG)

