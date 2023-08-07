FROM alpine:latest AS collector
RUN apk add --no-cache --update \
    bash \
    curl \
    jq=1.6-r3

WORKDIR /collector
COPY ./scripts/collector.sh /collector/collector.sh
RUN chmod +x collector.sh && ./collector.sh

FROM alpine:latest AS lambda
RUN apk add --no-cache --update \
    curl \
    jq=1.6-r3

ENV LAMBDA_RIE="https://github.com/aws/aws-lambda-runtime-interface-emulator/releases/latest/download/aws-lambda-rie"
ENV LAMBDA_TASK_ROOT=/var/task
ENV LAMBDA_RUNTIME_DIR=/var/runtime

ADD ${LAMBDA_RIE} /usr/bin/aws-lambda-rie
RUN chmod 755 /usr/bin/aws-lambda-rie

COPY ./scripts/entry.sh /entry.sh
RUN chmod 755 /entry.sh

COPY ./scripts/bootstrap ${LAMBDA_RUNTIME_DIR}/bootstrap
RUN chmod 755 ${LAMBDA_RUNTIME_DIR}/bootstrap

COPY ./scripts/lambda.sh ${LAMBDA_TASK_ROOT}/lambda.sh
COPY --from=collector /collector/starred_repos.json ${LAMBDA_TASK_ROOT}/starred_repos.json
RUN chmod 755 ${LAMBDA_TASK_ROOT}/lambda.sh

ENTRYPOINT [ "/entry.sh" ]
CMD [ "lambda.handler" ]
