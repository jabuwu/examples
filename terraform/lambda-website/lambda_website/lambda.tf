data "aws_caller_identity" "current" {
}

# Setup IAM role for lambda to log to CloudWatch
data "aws_iam_policy_document" "lambda_role_policy_document" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "lambda_policy_document" {
  statement {
    actions = ["logs:CreateLogStream", "logs:PutLogEvents"]
    resources = [
      "arn:aws:logs:us-east-1:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/*:*",
    ]
  }
  statement {
    actions = ["logs:CreateLogGroup"]
    resources = [
      "arn:aws:logs:us-east-1:${data.aws_caller_identity.current.account_id}:*",
    ]
  }
}

resource "aws_iam_role" "lambda_iam_role" {
  name               = "${var.prefix}_lambda_role"
  assume_role_policy = data.aws_iam_policy_document.lambda_role_policy_document.json
}

resource "aws_iam_role_policy" "lambda_role_policy" {
  name   = "${var.prefix}_lambda_role_policy"
  role   = aws_iam_role.lambda_iam_role.id
  policy = data.aws_iam_policy_document.lambda_policy_document.json
}

# Create lambda
resource "aws_lambda_function" "lambda" {
  function_name    = var.prefix
  filename         = var.filename
  source_code_hash = filebase64sha256(var.filename)
  role             = aws_iam_role.lambda_iam_role.arn
  handler          = var.handler
  runtime          = "nodejs12.x"
  memory_size      = "512"
  timeout          = "60"
}