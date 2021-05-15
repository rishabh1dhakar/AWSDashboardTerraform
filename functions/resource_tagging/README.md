# Resource Tagging

This function uses Resource Group Tagging API to apply a set of tags to the support AWS resources in all regions.

## Requirements

This function requires the following environment variables

| Name | Description | Required |
|------|-------------|----------|
|ORG_ACCOUNT|AWS Organization master account ID| Yes|
|FILE_PATH|Path to CSV file containing account IDs and assume role names. The header row should be `AccountID,Role`| Yes|

## Deployment

Make sure you have setup your AWS credentials accordingly. You will need the credentials for the `AWS Cinepolis Corp` account.

## Prerequisites.

Follow the [Prerequisites](../../documentation/Prerequisites.md) instructions to obtain and install the necessary tools.

### Environment setup

Once the installation is complete, set up your environment.

### Configure your SSO environment

Execute the following commands in order to configure your SSO env:
```shell
export AWS_DEFAULT_SSO_START_URL="https://d-906705f878.awsapps.com/start/"
export AWS_DEFAULT_SSO_REGION="us-east-1"
```

### Programmatic access
In order to use terraform, you need to have programmatic access to AWS (with ```AdministratorAccess``` level privileges).

There are multiple ways to set up your environment, but as the Cinepolis project is using an AWS SSO, we use the [aws-sso-util](https://github.com/benkehoe/aws-sso-util) tool to generate our ```~/.aws/config```.  

For convenience, we are providing a pre-generated ```~/.aws/config``` [credentials file](../../files/aws_sso_profiles) which is ready to go and could be added to your ```~/.aws/config``` file as is.

But, if you want and [as suggested before](../../documentation/Prerequisites.md) you could utilise the aws-sso-util to re-generate the file:


```shell
aws-sso-util configure populate --region us-east-1
```

This will create a new ```~/.aws/config``` file with the following format (it will add any accounts and roles to which you have access to in AWS SSO):
```shell
[profile AWS-Cinepolis-Corp.AWSAdministratorAccess]
sso_start_url = https://d-906705f878.awsapps.com/start/
sso_region = us-east-1
sso_account_name = AWS Cinepolis Corp
sso_account_id = 055148195790
sso_role_name = AWSAdministratorAccess
region = us-east-1
credential_process = aws-sso-util credential-process --profile AWS-Cinepolis-Corp.AWSAdministratorAccess
sso_auto_populated = true
```

### Deploy Terraform Code

1. Login to the AWS organization account
```
aws sso login --profile AWS-Cinepolis-Corp.AWSAdministratorAccess
```

1. First, initialize Terraform
```
cd terraform
terraform init
```

1. Run Terraform plan to verify your changes (Dry-Run)
```
terraform plan
```

1. Apply Terraform changes
```
terraform apply
```

## Notes

Resource Group Tagging API will only tag resources that have tags or used to have tags. Newly created resources without tags will not be identified. This is how the API works.

In order to resolve this issue, we should create a dummy tag for all resources in all regions on the AWS Tag Editor console before executing this function. The dummy tag can be removed after that.
