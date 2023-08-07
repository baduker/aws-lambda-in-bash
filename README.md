# aws-lambda-in-bash
An experiment in writing an AWS Lambda in bash only

### How to run it?

1. Build it.
```bash
make build
```
2. Run it.
```bash
docker run -p 9000:8080 aws-lambda-in-bash:latest /var/runtime/bootstrap lambda.handler
```

3. Test it.
```bash
curl -XPOST "http://localhost:9000/2015-03-31/functions/function/invocations" -d '{"event": "Bash to the future!"}'
```
