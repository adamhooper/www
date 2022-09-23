terraform {
  backend "s3" {
    bucket = "terraform-state.adamhooper.com"
    key    = "adamhooper.com/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
}

module "terraform_aws_static_website" {
  source      = "git@github.com:infrable-io/terraform-aws-static-website.git"
  domain_name = "adamhooper.com"
}
