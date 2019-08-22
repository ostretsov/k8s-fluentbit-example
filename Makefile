.PHONY: build-and-push
image = log-producer
build-and-push:
	docker build -t $(image) .
	docker push $(image)