# Terratest with localstack
![meetup](images/meetup.jpeg)

[MeetUp](https://www.meetup.com/bangkok-hashicorp-user-group/events/285735427/)

[Slide](https://docs.google.com/presentation/d/1K9RgCwA0Iegxz46gXw6trHoT8402jZTRKYw6WQUuR9k/edit?usp=sharing)
## LocalStack

> Information: to run the tests locally, you need to setup [localstack](https://docs.localstack.cloud/get-started/)

```
## Docker compose
docker-compose up

----------------------------------------------------------------------
## Checking localstack service running
curl localhost:4566/health | jq
----------------------------------------------------------------------

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
----------------------------------------------------------------------

## S3 test fix provider
### Remark this is fix to test on LocalStack only
cd test
go get -u -t -d -v ./... 

## TestAwsS3
go test -v -run TestAwsS3 -timeout 30m | tee test_output.log

```
## Run test without Terraform workspace to show the error of provider.
```
## TestAwsInstance
go test -v -run TestAwsInstance -timeout 30m | tee test_output.log

```
## How to test on LocalStack and AWS Cloud.
## Run test with Terraform workspace
```
## Dev environment
terraform workspace list
terraform workspace new dev
terraform workspace select dev
export TF_WORKSPACE=dev
echo $TF_WORKSPACE

## TestAwsInstance
go test -v -run TestAwsInstance -timeout 30m | tee test_output.log

## Option terraform process
terraform init
terraform plan -var-file terraform.tfvars -out output.tfplan
terraform apply "output.tfplan"
terraform destroy -var-file terraform.tfvars -auto-approve
----------------------------------------------------------------------

## Prod environment
unset TF_WORKSPACE
export AWS_PROFILE=default
terraform workspace list
terraform workspace new prod
terraform workspace select prod
export TF_WORKSPACE=prod
echo $TF_WORKSPACE

## TestAwsInstance
go test -v -run TestAwsInstance -timeout 30m | tee test_output.log

## Option terraform process
terraform init
terraform plan -var-file terraform.tfvars -out output.tfplan
terraform apply "output.tfplan"
terraform destroy -var-file terraform.tfvars -auto-approve
----------------------------------------------------------------------
```
## AWS local run
```
## Full endpoint-url
aws --endpoint-url=http://localhost:4566 ec2 describe-instances --query 'Reservations[].Instances[].[InstanceId,InstanceType,PublicIpAddress,Tags[?Key==`Name`]| [0].Value]' --output table --region us-east-1


## Use alias endpoint-url
export LOCALSTACK_URL=http://localhost:4566
alias aws="aws --endpoint-url $LOCALSTACK_URL"

aws ec2 describe-instances --query 'Reservations[].Instances[].[InstanceId,InstanceType,PublicIpAddress,Tags[?Key==`Name`]| [0].Value]' --output table --region us-east-1
                                              
```