#!/bin/sh

if [ -z "${AWS_LAMBDA_RUNTIME_API}" ]; then
  exec /usr/bin/aws-lambda-rie "$@"
else
  exec /var/runtime/bootstrap awslambdaric "$@"
fi
