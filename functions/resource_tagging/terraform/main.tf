data "archive_file" "resource_tagging" {
  type = "zip"
  source_dir = "../"
  excludes = ["terraform"]
  output_path = "resource_tagging.zip"
}

module "lambda_function" {
  source = "terraform-aws-modules/lambda/aws"
  function_name = "resource_tagging"
  handler       = "resource_tagging.lambda_handler"
  runtime       = "python3.8"
  create_package         = false
  local_existing_package = "resource_tagging.zip"
  attach_policy = true
  policy = "arn:aws:iam::aws:policy/PowerUserAccess"
  timeout = 900
  tags = {
    Name = "resource_tagging"
  }
  environment_variables = {
    ORG_ACCOUNT = 055148195790
    FILE_PATH = "account.csv"
  }
}

terraform {
  backend "s3" {
    region  = "us-east-1"
    bucket  = "st-usa-055148195790-tfstate-s3"
    encrypt = true
    key     = "terraform-bootstrap/resource_tagging.tfstate"
  }
}
