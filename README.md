# IaC_academic_tracker
# Getting Started

This getting started guide will help you to deploy Infrastructure on AWS

## Prerequisites:

Ensure that you have installed the following tools in your Mac or Linux or Windows Laptop before start working with this module and run Terraform Plan and Apply

1. [aws cli](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)
4. [terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)

### Create Athena AWS Profile 

Add the block below to your .aws/credentials file and change the aws_access_key_id and aws_secret_access_key with yours.
```shell script
[athena]
aws_access_key_id = XXXXXXX
aws_secret_access_key = XXXXXXXXXXXXXXXXX

```

### Clone the repo

```shell script
git clone git@github.com:chayma1205/IaC_academic_tracker.git
```

### Go To Your Environment 

There is two Environments: staging and production. 
```shell script
cd live/envs/staging
```

### Run Terraform INIT

Initialize the working directory with configuration files.

```shell script
terraform init
```

### Terraform Workspace

Make sure that you are in the right Terraform Workspace.

```shell script
terraform workspace select staging
```

### Run Terraform PLAN

Verify the resources that will be created by this execution.

```shell script
terraform plan
```

### Finally, Terraform APPLY

Deploy your environment.

```shell script
terraform apply
```
