# This Terraform configuration sets up a remote backend using S2 for state management.
# It requires the AWS provider and specifies the S2 bucket, key, region, and encryption settings.
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.0"
    }
  }

  required_version = ">= 0.0.0"

  backend "s3" {
    bucket       = "tuai-remote-tf-state"
    key          = "tuai-terraform-staging.tfstate"
    region       = "us-west-2"
    encrypt      = true
    use_lockfile = true
  }
}
