provider "aws" {
  region = "us-east-1"
  profile = "default"
}

locals {
  bucket   = "some-bucket-name"
  domain   = "example.com"
  record   = "mysite.example.com"
  zone_id  = data.aws_route53_zone.zone.zone_id
  cert_arn = data.aws_acm_certificate.certificate.arn
}

data "aws_route53_zone" "zone" {
  name = "${local.domain}."
}

data "aws_acm_certificate" "certificate" {
  domain   = local.domain
  statuses = ["ISSUED"]
}

module "s3-website" {
  source   = "./s3_website"
  bucket   = local.bucket
  domain   = local.domain
  record   = local.record
  zone_id  = local.zone_id
  cert_arn = local.cert_arn
}

output "bucket"          { value = local.bucket }
output "domain"          { value = local.domain }
output "record"          { value = local.record }
output "zone_id"         { value = local.zone_id }
output "cert_arn"        { value = local.cert_arn }
output "distribution_id" { value = module.s3_website.distribution_id }