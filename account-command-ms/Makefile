IMG ?= us.icr.io/paolo/account-command-ms
TAG ?= 1.0.0
NS ?=thinkdemo

test: 
	mvn test

build:
	cd .. && mvn install -DskipTests
	mvn package -DskipTests
	docker build -f src/main/docker/Dockerfile.jvm -t ${IMG}:${TAG} .

push:
	docker push ${IMG}:${TAG}

run:
	./mvnw compile quarkus:dev: -Ddebug=5005

deploy:
	sed "s|CLUSTER_NAMESPACE|${NS}|;s|IMAGE_AND_TAG|${IMG}:${TAG}|" k8s/deployment.yaml | kubectl apply -f -
	sed "s|CLUSTER_NAMESPACE|${NS}|" k8s/service.yaml | kubectl apply -f -
	
create-cos-secret:
	kubectl create secret generic cos-secret \
	--from-literal=API_KEY=${API_KEY} \
	--from-literal=SERVICE_INSTANCE_ID=${SERVICE_INSTANCE_ID} \
	--from-literal=ENDPOINT_URL=${ENDPOINT_URL} \
	--from-literal=LOCATION=${LOCATION} \
	--from-literal=ACCOUNTS_BUCKET=${ACCOUNTS_BUCKET} \
	--from-literal=USERS_BUCKET=${USERS_BUCKET}
