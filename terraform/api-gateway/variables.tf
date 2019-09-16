
variable "aws-region" {
  description = "AWS Region - must be staged for different HUB"
  default = "eu-central-1"
}



variable "api-name" {
  description = "Name of the API"
  default = "S3API"
}

variable "integration-uri" {
  description = "Integration URI Pointing to S3"
  default = "arn:aws:apigateway:eu-central-1:s3:path/your-s3-bucket/{file}"
}


variable "api-key" {
  description = "the API Key"
  default = "1234567"
}



