.PHONY: build

VERSION = 2.4.4
BUILD = r68
TAG = $(VERSION)
REPO = dil001/spark

build:
	docker build -t $(REPO) .
	docker tag $(REPO) $(REPO):v$(TAG)
	docker tag $(REPO) $(REPO):v$(TAG)-$(BUILD)

push:
	docker push $(REPO)
	docker push $(REPO):v$(TAG)
	docker push $(REPO):v$(TAG)-$(BUILD)

clean:
	docker rmi $(REPO)
	docker rmi $(REPO):v$(TAG)
	docker rmi $(REPO):v$(TAG)-$(BUILD)

