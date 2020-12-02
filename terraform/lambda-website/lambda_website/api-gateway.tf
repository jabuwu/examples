# Create the Rest API
resource "aws_api_gateway_rest_api" "api" {
  name               = var.prefix
  binary_media_types = ["*/*"]
}

# Create the root method
resource "aws_api_gateway_method" "api_method_root" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_rest_api.api.root_resource_id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "api_integration_root" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_method.api_method_root.resource_id
  http_method             = aws_api_gateway_method.api_method_root.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda.invoke_arn
}

# Create the proxy+ method
resource "aws_api_gateway_resource" "api_resource" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "api_method" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.api_resource.id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "api_integration" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_method.api_method.resource_id
  http_method             = aws_api_gateway_method.api_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda.invoke_arn
}

# Create the deployment
resource "aws_api_gateway_deployment" "api_deployment" {
  depends_on = [
    aws_api_gateway_integration.api_integration_root,
    aws_api_gateway_integration.api_integration,
  ]
  rest_api_id = aws_api_gateway_rest_api.api.id
  stage_name  = "deployment"
}

# Create the permissions to invoke lambda
resource "aws_lambda_permission" "web_gateway_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_deployment.api_deployment.execution_arn}/*/*"
}

# Create API Gateway domain name
resource "aws_api_gateway_domain_name" "domain_name" {
  domain_name              = var.record
  regional_certificate_arn = var.cert_arn
  endpoint_configuration {
    types = [
      "REGIONAL",
    ]
  }
}

# Create regional mapping
resource "aws_api_gateway_base_path_mapping" "regional" {
  api_id      = aws_api_gateway_rest_api.api.id
  stage_name  = "deployment"
  domain_name = aws_api_gateway_domain_name.domain_name.domain_name
}