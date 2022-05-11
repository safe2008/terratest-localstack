package test

import (
	"fmt"
	"os"
	"testing"
	"time"
	"crypto/tls"

	http_helper "github.com/gruntwork-io/terratest/modules/http-helper"
	test_structure "github.com/gruntwork-io/terratest/modules/test-structure"
	"github.com/stretchr/testify/assert"

	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestAwsInstance(t *testing.T) {
	t.Parallel()

	workingDir := test_structure.CopyTerraformFolderToTemp(t, "../", "/instance")

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: workingDir,
	})

	// At the end of the test, run `terraform destroy` to clean up any resources that were created.
	defer terraform.Destroy(t, terraformOptions)

	// Run `terraform init` and `terraform apply`. Fail the test if there are any errors.
	terraform.InitAndApply(t, terraformOptions)

	// Run `terraform output` to get the IP of the instance
	ip_addresses := terraform.Output(t, terraformOptions, "ip_addresses")
	assert.NotNil(t, ip_addresses)

	vpc_id := terraform.Output(t, terraformOptions, "vpc_id")
	assert.NotNil(t, vpc_id)

	vpc_public_subnets := terraform.Output(t, terraformOptions, "vpc_public_subnets")
	assert.NotNil(t, vpc_public_subnets)

	webserver_ids := terraform.Output(t, terraformOptions, "webserver_ids")
	assert.NotNil(t, webserver_ids)

	tf_workspace := ""
	if fromEnv := os.Getenv("TF_WORKSPACE"); fromEnv != "" {
		tf_workspace = fromEnv
	}

	tlsConfig := tls.Config{}

	if tf_workspace == "prod" {
		url := fmt.Sprintf("http://%s", ip_addresses)
		http_helper.HttpGetWithRetryWithCustomValidation(
			t,
			fmt.Sprintf(url),
			&tlsConfig,
			30,
			10 * time.Second,
			func(statusCode int, body string) bool {
				return statusCode == 200
			},
		)
	}
}
