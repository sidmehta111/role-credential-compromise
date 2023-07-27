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
  default = "PrismaCloud-credcomp-bucket"
}
#Cidr blocks that can access EC2 via ssh
variable "credcomp-cidr-ssh" {
  default = [
    "199.167.52.5/32",
    "137.83.193.95/32"
  ]
}
#Cidr blocks that can access EC2 via http
variable "credcomp-cidr-http" {
  default = [
    "199.167.52.5/32",
    "137.83.193.95/32"
  ]
}