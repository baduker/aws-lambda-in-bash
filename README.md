# aws-lambda-in-bash
An experiment in writing an AWS Lambda in bash only

### TL;DR

This is a proof of concept that you can write an AWS Lambda in (ba)sh only.
It uses the [AWS Lambda Runtime Interface Emulator](https://github.com/aws/aws-lambda-runtime-interface-emulator)
to communicate with the AWS Lambda Runtime API.

Also, it uses the AWS Lambda [custom runtime](https://docs.aws.amazon.com/en_us/lambda/latest/dg/runtimes-custom.html)
capability to run a bash script as a Lambda function.

### Why?

Well, why not? I wanted to see if it was possible to write an entire Lambda
that way.

It doesn't really have any practical use-case nor is meant to be used in
production, but it is a fun experiment.

### How to run it locally?

1. Build it.
```bash
make build
```
2. Run it.
```bash
make run
```

3. Open another terminal window and test it.
```bash
make test
```

If all goes well, you should see a random starred repo from my GitHub account.

*Note: Obviously the output will be different for you. But you can keep testing it
until you get the same repo twice in a row. That's when you know it's working. ;)*

```json
{
  "statusCode": 200,
  "random_repo": {
    "repo_name": "my_first_calculator.py",
    "data": {
      "url": "https://github.com/AceLewis/my_first_calculator.py",
      "description": "my_first_calculator.py",
      "language": "Python",
      "full_url": "https://github.com/AceLewis/my_first_calculator.py",
      "stars": 3897,
      "name": "my_first_calculator.py",
      "homepage": null,
      "ssh_url": "git@github.com:AceLewis/my_first_calculator.py.git"
    }
  }
}% 
```

### How to deploy it to AWS?



