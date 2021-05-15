#Usage

In order to deploy the code in this repo you need to do the following.

## Prerequisites.

Follow the [Prerequisites](./Prerequisites.md) instructions to obtain and install the necessary tools. 

## Environment setup

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

For convenience, we are providing a pre-generated ```~/.aws/config``` [credentials file](../files/aws_sso_profiles) which is ready to go and could be added to your ```~/.aws/config``` file as is. 

But, if you want and [as suggested before](Prerequisites.md) you could utilise the aws-sso-util to re-generate the file:


```shell
aws-sso-util configure populate --region us-east-1
```

This will create a new ```~/.aws/config``` file with the following format (it will add any accounts and roles to which you have access to in AWS SSO):
```shell
[profile ACCOUNT_NAME.ROLE_NAME]
sso_start_url = https://d-906705f878.awsapps.com/start/
sso_region = us-east-1
sso_account_name = US-TestUAT-CNPLS-01
sso_account_id = 107572963064
sso_role_name = AWSAdministratorAccess
region = us-east-1
credential_process = aws-sso-util credential-process --profile US-TestUAT-CNPLS-01.AWSAdministratorAccess
sso_auto_populated = true
```

### Configure your Terraform environment

As we use the same terraform codebase for all AWS accounts you need to have a backend.tfvars for each AWS account in which you want to deploy to.

It's location should be in ```backend-config/${AWS_ACCOUNT_PROFILE_NAME}``` and it should have the following structure:

```shell
bucket     = "${bucket}"
kms_key_id = "${kms_key_id}"
region     = "${region}"
```

where:

* **bucket** - terraform state bucket name in the respective AWS account 
* **kms_key_id** - the KMS Key Alias with which the terraform state S3 bucket is encrypted
* **region** - the AWS region

**Please note that the name of the directory for the respective AWS account should be an exact match to the AWS SSO profile name for that account.**

For convenience, we are providing a pre-generated file with folder names (account names) that are matching the account profile names in the [aws_sso_profiles](../files/aws_sso_profiles) file. 

This file is named [backend_config_dirs](../files/backend_config_dirs) and it's available in the same [files folder](../files/).

## How to apply your terraform code

### Deploy to all AWS accounts

In order to deploy our code to all AWS accounts at once we have created a wrapper shell script named [terraform_deploy.sh](../scripts/terraform_deploy.sh),
that is:
* looping over the list of accounts available in the [backend_config_dirs](../files/backend_config_dirs)
* logging into each AWS account by assuming a role in the account (by using the ```awsume``` command which is relying on the profiles configured in ```~/.aws/config``` as provided in the [aws_sso_profiles](../files/aws_sso_profiles))
*  ```terraform init```
* ```terraform apply -auto-approve```

#### Using [terraform_deploy.sh](../scripts/terraform_deploy.sh)

1. **Authenticate to AWS SSO**
   
Before you use the script you'll need to authenticate to AWS SSO at least once:

 ```aws sso login --profile ACCOUNTNAME.AWSAdministratorAccess```

2. Set up ```PROJECT_SRC_ROOT``` 

In your project root folder (cd into REPO_ROOT) - e.g. **softline-cinepolis** run:

```shell
export PROJECT_SRC_ROOT=`pwd`
```

3. Execute [terraform_deploy.sh](../scripts/terraform_deploy.sh)

The script supports the following options:
```shell
./terraform_deploy.sh -h
Usage: terraform_deploy.sh [option...] {plan|apply}

   -h, --help           show this help text
   -a, --accounts       please provide a list of accounts in which to do terraform apply
   -t, --tf_dir         please provide the directory in which to do a terraform apply
```

where:
* **-a --accounts** - we provide a file with a list of accounts to which we want to deploy
* **-t --tf_dir** - we provide the path to directory with the terraform code which we want to deploy

For example, in order to deploy the Monitoring dashboard solution to all 42 accounts we have to execute the script like this:

```shell
terraform_deploy.sh -a $PROJECT_SRC_ROOT/files/backend_config_dirs -t $PROJECT_SRC_ROOT/monitoring-dashboard apply 2>&1 | tee -a -i execution.log
```

### Deploy to a single AWS Account

You can deploy to only one account by using the terraform_deploy.sh script or by running terraform directly.

#### Automatic terraform deployment by using the script

The only difference compared to the explanation for all AWS accounts above is that instead of providing a file list with all AWS accounts,
you have to provide a file which has just a few or a single AWS account name in it.

For example:
```shell
terraform_deploy.sh -a STANDALONE_ACCOUNT_NAME -t $PROJECT_SRC_ROOT/monitoring-dashboard apply 2>&1 | tee -a -i execution.log
```

#### Manual terraform deployment

If you don't want to use the wrapper script, and want to use the native terraform commands instead, 
you can do so by, again follow the steps from the automatic deployment to all AWS accounts above, 
but instead of using the script on Step 3, you can:

1. set your path
```shell
export PROJECT_SRC_ROOT=`pwd`
```

2. Enter the directory which you want to deploy:

```shell
cd monitoring-dashboard
```

3. Cleanup any residue from previous exections in this folder
```shell
rm -rf .terraform && rm -f .terraform.lock.hcl && rm -f terraform.tfstate*
```

4. Assume role in the account to which you want to apply

Assume role in the account by using the profile_name for that account which you have in your ```~/.aws/config``` file.

For example, for the **US-TestUAT-CNPLS-01** account:

```shell
awsume US-TestUAT-CNPLS-01.AWSAdministratorAccess
```

5. Run terraform

* terraform init - to initialize the terraform backend

```hcl
terraform init -backend-config=$PROJECT_SRC_ROOT/backend-config/`echo $AWSUME_PROFILE | cut -d . -f1`/backend.tfvars
```

* terraform plan - to check what changes are going to be made (plan is basically a dry-run)

```hcl
terraform plan -var-file=$PROJECT_SRC_ROOT/backend-config/`echo $AWSUME_PROFILE | cut -d . -f1`/config.tfvars
```

* terraform apply - to actually deploy any outstanding changes

```hcl
terraform apply -var-file=$PROJECT_SRC_ROOT/backend-config/`echo $AWSUME_PROFILE | cut -d . -f1`/config.tfvars
```

## Additional notes

### How to remove an AWS account

As a best practice, prior removing an account from the environment you should first remove any resources from it.

In order to do so, you can follow the [manual terraform deployment](#manual-terraform-deployment) above, but on the last step, you need to replace ```apply``` with ```destroy```.

Once done, you can then remove this account folder from the [backend-config](../backend-config), 
and then remove its profile from ```~/.aws/config``` on your PC or laptop and in any additional file in the repo like [aws_sso_profiles](../files/aws_sso_profiles) or [backend_config_dirs](../files/backend_config_dirs).

In case the account has already been decommissioned, just remove its folder and name from any files as per above.

### How to add and deploy to a newly created AWS account

#### Add newly created AWS account

In order to deploy to any newly created AWS accounts you need to do the following

1. Set up a profile for it in ```~/.aws/config```
2. Add its profile name to [aws_sso_profiles](../files/aws_sso_profiles)
3. Add it to the [backend_config_dirs](../files/backend_config_dirs)
4. Create a folder with a name matching the AWS account profile name added to 2 and 3 above under [backend-config](../backend-config)
5. Create a ```backend.tfvars``` file with only a region stanza: ```region     = "us-east-1"```
6. Create a ```config.tfvars``` file with only a region stanza: ```region     = "us-east-1"```
6. Enter the [terraform-bootstrap](../terraform-bootstrap) folder
7. Run ```mv state.tf state.tf.backup```
8. Follow the  [manual terraform deployment](#manual-terraform-deployment) and execute terraform apply
9. Run  ```mv state.tf.backup state.tf```
10. Re-run ```terraform apply```

You will be asked whether you want to upload the state file to s3, respond with **Yes**.
```Do you want to copy existing state to the new backend?
  Pre-existing state was found while migrating the previous "local" backend to the
  newly configured "remote" backend. No existing state was found in the newly
  configured "remote" backend. Do you want to copy this state to the new "remote"
  backend? Enter "yes" to copy and "no" to start with an empty state.
  ```

12. You are all set. 
    
You can now deploy any of the other solutions to the new account by following the [standalone automatic deployment](deploy-to-a-single-aws-account) or [manual terraform deployment](#manual-terraform-deployment) in the solution respective folder (e.g. monitoring-dashboard)