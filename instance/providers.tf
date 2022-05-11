locals {
  use_localstack = (terraform.workspace == "dev")

  aws_settings = (
    local.use_localstack ?
    {
      region                      = local.region
      access_key                  = "fake"
      secret_key                  = "fake"
      s3_force_path_style         = true
      skip_credentials_validation = true
      skip_metadata_api_check     = true
      skip_requesting_account_id  = true

      skip_credentials_validation = true
      skip_metadata_api_check     = true
      skip_requesting_account_id  = true

      override_endpoint = "http://localstack:4566"
    } :
    {
      region     = local.region
      access_key = null
      secret_key = null

      skip_credentials_validation = null
      skip_metadata_api_check     = null
      skip_requesting_account_id  = null

      override_endpoint = null
    }
  )
}

provider "aws" {
  region     = local.aws_settings.region
  access_key = local.aws_settings.access_key
  secret_key = local.aws_settings.secret_key

  skip_credentials_validation = local.aws_settings.skip_credentials_validation
  skip_metadata_api_check     = local.aws_settings.skip_metadata_api_check
  skip_requesting_account_id  = local.aws_settings.skip_requesting_account_id

  dynamic "endpoints" {
    for_each = local.aws_settings.override_endpoint[*]
    content {
      apigateway       = endpoints.value
      cloudformation   = endpoints.value
      cloudwatch       = endpoints.value
      cloudwatchevents = endpoints.value
      dynamodb         = endpoints.value
      ec2              = endpoints.value
      es               = endpoints.value
      firehose         = endpoints.value
      iam              = endpoints.value
      kinesis          = endpoints.value
      lambda           = endpoints.value
      route53          = endpoints.value
      redshift         = endpoints.value
      s3               = endpoints.value
      secretsmanager   = endpoints.value
      ses              = endpoints.value
      sns              = endpoints.value
      sqs              = endpoints.value
      ssm              = endpoints.value
      stepfunctions    = endpoints.value
      sts              = endpoints.value
    }
  }
}