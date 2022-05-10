# terratest-localstack

## Tests

> Warning: to run the tests locally, you need to setup [localstack](https://docs.localstack.cloud/get-started/)

```
docker-compose up

docker run --rm -it -p 4566:4566 -p 4571:4571 localstack/localstack

## Starting LocalStack Pro or Enterprise using Docker
export LOCALSTACK_API_KEY=xxxxxx

docker run  --name localstack \
  --rm -it \
  -p 4566:4566 \
  -p 4571:4571 \
  -e LOCALSTACK_API_KEY=${LOCALSTACK_API_KEY:- } \
  localstack/localstack

./tf-ls.sh init
./tf-ls.sh plan -var-file tfvars/localstack.tfvars -out output.tfplan
./tf-ls.sh apply output.tfplan 
./tf-ls.sh destroy -var-file tfvars/localstack.tfvars -auto-approve

aws configure --profile mylocalstack                                                         
AWS Access Key ID [None]: temp
AWS Secret Access Key [None]: temp
Default region name [None]: us-east-1
Default output format [None]:

export AWS_PROFILE=mylocalstack
export LOCALSTACK_URL=http://localstack:4566

export AWS_ACCESS_KEY_ID=test
export AWS_SECRET_ACCESS_KEY=test
export AWS_DEFAULT_REGION=us-east-1

terraform plan -var-file=terraform.tfvars
terraform apply -var-file=terraform.tfvars -auto-approve

export BUCKET_NAME=boriphuth-infra
aws s3 ls s3://$BUCKET_NAME|| (aws s3 mb s3://$BUCKET_NAME --region $AWS_DEFAULT_REGION && aws s3api put-bucket-versioning --bucket $BUCKET_NAME --versioning-configuration Status=Enabled)

export LOCALSTACK_URL=http://localhost:4566
alias aws="aws \
    --endpoint-url $LOCALSTACK_URL"

aws ec2 describe-instances --query 'Reservations[].Instances[].[InstanceId,InstanceType,PublicIpAddress,Tags[?Key==`Name`]| [0].Value]' --output table --region us-east-1

aws --endpoint-url=http://localhost:4566 ec2 describe-instances --query 'Reservations[].Instances[].[InstanceId,InstanceType,PublicIpAddress,Tags[?Key==`Name`]| [0].Value]' --output table --region us-east-1

aws eks create-cluster \
    --name my-cluster \
    --role-arn r1 \
    --resources-vpc-config '{}'

aws eks list-clusters

aws eks describe-cluster --name my-cluster

## Checking license activation
curl localhost:4566/health | jq

cd tests
go test -v -timeout 30m | tee test_output.log

## Test with name
go test -v -run TestAwsInstance -timeout 30m    
go test -v -run TestAwsS3 -timeout 30m                                                   

```