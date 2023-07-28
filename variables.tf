#All variables are required to change
#AWS Region
variable "region" {
  default = "us-east-1"
}
#Stack Name
variable "stack-name" {
  default = "PrismaCloud-CredentialCompromise"
}
#Scenario Name
variable "scenario-name" {
  default = "PrismaCloud-ec2-ssrf"
}
#s3 bucket to simulate attack
variable "credcomp-s3-bucket" {
  default = "prismacloud-credcomp-bucket"
}
