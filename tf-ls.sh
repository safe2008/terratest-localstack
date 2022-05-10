#!/bin/sh
set -e

docker run --rm -it -v $PWD:/workspace \
    -v $PWD/localstack/providers.tf:/workspace/aws/providers.tf \
    -w /workspace/aws \
    --network localstack hashicorp/terraform $@