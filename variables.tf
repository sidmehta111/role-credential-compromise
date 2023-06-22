#All variables are required to change
#AWS Profile
variable "profile" {
  default = "pentest"
}
#AWS Region
variable "region" {
  default = "us-west-1"
}
#CGID Variable for unique naming
variable "cgid" {
  default = "rtg"
}
#SSH Public Key
variable "ssh-public-key-for-ec2" {
  default = "../credcomp.pub"
}
#SSH Private Key
variable "ssh-private-key-for-ec2" {
  default = "../credcomp"
}
#Stack Name
variable "stack-name" {
  default = "CredentialCompromise"
}
#Scenario Name
variable "scenario-name" {
  default = "ec2-ssrf"
}
#Vpc Id
#variable "vpc-id" {
#  default = <vpc_id>
#}
#Vpc Id
#variable "subnet-id" {
#  default = <subnet_id>
#}
#s3 bucket to simulate attack
variable "credcomp-s3-bucket" {
  default = "rtg-credcomp-test-bucket"
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