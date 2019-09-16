# Terraform Batch Job Definition
# Provider: AWS
# Region: Frankfurt
provider "aws" {
  region = "${var.aws-region}"
  #profile = "${var.aws-profile}"
}


###########resources###########
# S3 Full Access Policy
resource "aws_iam_policy" "s3_policy" {
  name        = "s3-policy"
  description = "Policy for allowing all S3 Actions"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
             "s3:Get*",
             "s3:List*"
            ],
            "Effect": "Allow",
            "Resource": "*"
        }
    ]
}
EOF
}

# API Gateway Role
resource "aws_iam_role" "s3_api_gateyway_role" {
  name = "s3-api-gateyway-role"

  # Create Trust Policy for API Gateway
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "apigateway.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
} 
  EOF
}
# Attach S3 Access Policy to the API Gateway Role
resource "aws_iam_role_policy_attachment" "s3_policy_attach" {
  role       = "${aws_iam_role.s3_api_gateyway_role.name}"
  policy_arn = "${aws_iam_policy.s3_policy.arn}"
}

resource "aws_api_gateway_rest_api" "S3API" {
  name        = "${var.api-name}"
  description = "S3 Files Download API"
  binary_media_types = ["*/*"]
   endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_resource" "r1" {
  rest_api_id = "${aws_api_gateway_rest_api.S3API.id}"
  parent_id   = "${aws_api_gateway_rest_api.S3API.root_resource_id}"
  path_part   = "yelp"
}


resource "aws_api_gateway_resource" "r2" {
  rest_api_id = "${aws_api_gateway_rest_api.S3API.id}"
  parent_id   = "${aws_api_gateway_resource.r1.id}"
  path_part   = "{file}"
}

resource "aws_api_gateway_method" "GetFiles" {
  rest_api_id   = "${aws_api_gateway_rest_api.S3API.id}"
  resource_id   = "${aws_api_gateway_resource.r2.id}"
  http_method   = "GET"
  authorization = "NONE"
  api_key_required = "true"
  request_parameters = {
    "method.request.path.file" = true
    "method.request.header.Content-Type"  = true
    }
}

resource "aws_api_gateway_integration" "integration" {
  rest_api_id             = "${aws_api_gateway_rest_api.S3API.id}"
  resource_id             = "${aws_api_gateway_resource.r2.id}"
  http_method             = "${aws_api_gateway_method.GetFiles.http_method}"
  integration_http_method = "GET"
  type                    = "AWS"
  uri                     = "${var.integration-uri}"
  credentials = "${aws_iam_role.s3_api_gateyway_role.arn}"
  request_parameters = {
    "integration.request.path.file" = "method.request.path.file"
    "integration.request.header.Content-Type"           = "'Content-Type'"
  }
}

resource "aws_api_gateway_method_response" "response" {
  rest_api_id = "${aws_api_gateway_rest_api.S3API.id}"
  resource_id = "${aws_api_gateway_resource.r2.id}"
  http_method = "${aws_api_gateway_method.GetFiles.http_method}"
  status_code = "200"

    response_parameters = {
    "method.response.header.Timestamp"      = true
    "method.response.header.Content-Length" = true
    "method.response.header.Content-Type"   = true
  }

  response_models = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_integration_response" "integrationResponse" {
  rest_api_id = "${aws_api_gateway_rest_api.S3API.id}"
  resource_id = "${aws_api_gateway_resource.r2.id}"
  http_method = "${aws_api_gateway_method.GetFiles.http_method}"
  status_code = "${aws_api_gateway_method_response.response.status_code}"

}

resource "aws_api_gateway_deployment" "dev" {
  depends_on  = ["aws_api_gateway_integration.integration"]
  rest_api_id = "${aws_api_gateway_rest_api.S3API.id}"
  stage_name  = "dev"
}

resource "aws_api_gateway_api_key" "api-key" {
  name = "api-key"
  value = "${var.api-key}"
}


resource "aws_api_gateway_usage_plan" "usagePlan" {
  name         = "yelp-usage-plan"
  product_code = "YELP"

  api_stages {
    api_id = "${aws_api_gateway_rest_api.S3API.id}"
    stage  = "${aws_api_gateway_deployment.dev.stage_name}"
  }
}
resource "aws_api_gateway_usage_plan_key" "up_apikey" {
  key_id        = "${aws_api_gateway_api_key.api-key.id}"
  key_type      = "API_KEY"
  usage_plan_id = "${aws_api_gateway_usage_plan.usagePlan.id}"
}