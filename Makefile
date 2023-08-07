DOCKER_IMAGE ?= aws-lambda-in-bash
DEFAULT_REGION ?= eu-central-1
FUNCTION_NAME ?= lambda-in-bash

build:
	@docker build -t "$(DOCKER_IMAGE)":latest .

run:
	@docker run -p 9000:8080 "$(DOCKER_IMAGE)":latest /var/runtime/bootstrap lambda.handler

test:
	@curl -XPOST "http://localhost:9000/2015-03-31/functions/function/invocations" -d '{"event": "Bash to the future!"}'

prune:
	@docker system prune --all --force

clean:
	@docker images | grep none | awk '{print $3;}' \
	| xargs docker rmi --force

run-collector:
	cd scripts && ./collector.sh

aws-ecr-login:
	@aws ecr get-login-password --region "$(DEFAULT_REGION)" \
	| docker login --username AWS --password-stdin \
	$(AWS_ACCOUNT_ID).dkr.ecr."$(DEFAULT_REGION)".amazonaws.com

aws-create-repo:
	@aws ecr create-repository --repository-name "$(DOCKER_IMAGE)" \
		--image-scanning-configuration scanOnPush=true \
		--image-tag-mutability MUTABLE

aws-tag-push:
	@docker tag "$(DOCKER_IMAGE):latest" $(AWS_ACCOUNT_ID).dkr.ecr.$(DEFAULT_REGION).amazonaws.com/$(DOCKER_IMAGE):latest && \
	docker push $(AWS_ACCOUNT_ID).dkr.ecr.$(DEFAULT_REGION).amazonaws.com/$(DOCKER_IMAGE):latest
