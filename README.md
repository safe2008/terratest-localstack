# Terratest with localstack
![meetup](images/meetup.jpeg)

[MeetUp](https://www.meetup.com/bangkok-hashicorp-user-group/events/285735427/)

[Slide](https://docs.google.com/presentation/d/1K9RgCwA0Iegxz46gXw6trHoT8402jZTRKYw6WQUuR9k/edit?usp=sharing)
## LocalStack

> Information: to run the tests locally, you need to setup [localstack](https://docs.localstack.cloud/get-started/)

```
## Docker compose

docker-compose up

## Checking license activation
curl localhost:4566/health | jq

## Aws configure
aws configure --profile mylocalstack                                                        
AWS Access Key ID [None]: test
AWS Secret Access Key [None]: test
Default region name [None]: us-east-1
Default output format [None]:

export AWS_PROFILE=mylocalstack
export LOCALSTACK_URL=http://localstack:4566

##Optional
export AWS_ACCESS_KEY_ID=test
export AWS_SECRET_ACCESS_KEY=test
export AWS_DEFAULT_REGION=us-east-1
```
## Run test
```
cd tests
## Test all
go test -v -timeout 30m | tee test_output.log

## Test without workspace
go test -v -run TestAwsS3 -timeout 30m
go test -v -run TestAwsInstance -timeout 30m 

```
## Terraform
```
## Dev environment
terraform workspace list
terraform workspace new dev
terraform workspace select dev
export TF_WORKSPACE=dev
echo $TF_WORKSPACE

terraform fmt --recursive
terraform init
terraform plan -var-file terraform.tfvars -out output.tfplan
terraform apply "output.tfplan"
terraform destroy -var-file terraform.tfvars -auto-approve

## Prod environment
export AWS_PROFILE=default
terraform workspace list
terraform workspace new prod
terraform workspace select prod
export TF_WORKSPACE=prod
echo $TF_WORKSPACE

terraform init
terraform plan -var-file terraform.tfvars -out output.tfplan
terraform apply "output.tfplan"
terraform destroy -var-file terraform.tfvars -auto-approve

```
## AWS local run
```
export LOCALSTACK_URL=http://localhost:4566
alias aws="aws \
    --endpoint-url $LOCALSTACK_URL"

aws ec2 describe-instances --query 'Reservations[].Instances[].[InstanceId,InstanceType,PublicIpAddress,Tags[?Key==`Name`]| [0].Value]' --output table --region us-east-1

aws --endpoint-url=http://localhost:4566 ec2 describe-instances --query 'Reservations[].Instances[].[InstanceId,InstanceType,PublicIpAddress,Tags[?Key==`Name`]| [0].Value]' --output table --region us-east-1
                                              
```