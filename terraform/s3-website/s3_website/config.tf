variable "bucket" {}
variable "domain" {}
variable "record" {}
variable "zone_id" {}
variable "cert_arn" {}

output "distribution_id" { value = aws_cloudfront_distribution.distribution.id }