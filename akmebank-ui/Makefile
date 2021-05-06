IMG ?= us.icr.io/paolo/akmebank-ui
TAG ?= 1.0.0

build:
	docker build -t ${IMG}:${TAG} .

push:
	docker push ${IMG}:${TAG}

run:
	npm run dev

deploy:
	@sed "s|IMAGE_AND_TAG|${IMG}:${TAG}|" k8s/deployment.yaml | kubectl apply -f -

