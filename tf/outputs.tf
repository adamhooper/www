output "s3_root_id" {
  value       = module.terraform_aws_static_website.s3_root_id
  description = "Root S3 bucket"
}

output "cf_distribution_id" {
  value       = module.terraform_aws_static_website.cf_distribution_id
  description = "CloudFront distribution ID"
}
