.PHONY: build

VERSION = 2.4.4
BUILD = r68
TAG = $(VERSION)
REPO = dil001/spark

build:
	docker build -t $(REPO) .
	docker tag $(REPO) $(REPO):$(TAG)
	docker tag $(REPO) $(REPO):$(TAG)-$(BUILD)

push:
	docker push $(REPO)
	docker push $(REPO):$(TAG)
	docker push $(REPO):$(TAG)-$(BUILD)

clean:
	docker rmi $(REPO)
	docker rmi $(REPO):$(TAG)
	docker rmi $(REPO):$(TAG)-$(BUILD)

