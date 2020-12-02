provider "aws" {
  region = "us-east-1"
  profile = "default"
}

locals {
  prefix   = "my-lambda-website"
  domain   = "example.com"
  record   = "mysite.example.com"
  filename = "./site.zip"
  handler  = "src/lambda.handler"
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

module "lambda_website" {
  source   = "./lambda_website"
  prefix   = local.prefix
  filename = local.filename
  handler  = local.handler
  record   = local.record
  zone_id  = local.zone_id
  cert_arn = local.cert_arn
}

output "prefix"   { value = local.prefix }
output "filename" { value = local.filename }
output "handler"  { value = local.handler }
output "domain"   { value = local.domain }
output "record"   { value = local.record }
output "zone_id"  { value = local.zone_id }
output "cert_arn" { value = local.cert_arn }