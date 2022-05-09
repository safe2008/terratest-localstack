# terratest-localstack

## Tests

> Warning: to run the tests locally, you need to setup [localstack](https://github.com/localstack/localstack)

```
## Starting LocalStack with Docker
docker run --rm -it -p 4566:4566 -p 4510-4559:4510-4559 localstack/localstack

## Starting LocalStack Pro or Enterprise using Docker
export LOCALSTACK_API_KEY=xxxxxx

docker run \
  --rm -it \
  -p 4566:4566 \
  -p 4510-4559:4510-4559 \
  -e LOCALSTACK_API_KEY=${LOCALSTACK_API_KEY} \
  localstack/localstack

cd tests
go test -v -timeout 30m | tee test_output.log

## Test with name
go test -v -run TestAwsS3Localstack -timeout 30m                                                   

```