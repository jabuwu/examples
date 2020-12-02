# Create Route 53 record
resource "aws_route53_record" "record" {
  zone_id = var.zone_id
  name    = aws_api_gateway_domain_name.domain_name.domain_name
  type    = "A"
  alias {
    name                   = aws_api_gateway_domain_name.domain_name.regional_domain_name
    zone_id                = aws_api_gateway_domain_name.domain_name.regional_zone_id
    evaluate_target_health = false
  }
}