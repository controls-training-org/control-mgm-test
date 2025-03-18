################################################################################
# Set required providers and version
################################################################################
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "terraform-state-storage20250309141114087600000002"
    region         = "eu-west-1"
    key            = "landingzone/terraform.tfstate"
    dynamodb_table = "terraform-state-storage"
    encrypt        = true
    kms_key_id     = "alias/terraform-state-storage"
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "eu-west-1"
  assume_role {
    role_arn = "arn:aws:iam::200223571282:role/RoleForAutomationPipeline"
  }
}
