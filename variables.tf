#AWS Region
variable "region" {
  default = "us-east-1"
}
#CGID Variable for unique naming
variable "cgid" {
  default = "prismacloud-credential-compromise"
}
#SSH Public Key
#variable "ssh-public-key-for-ec2" {
#  default = "../credcomp.pub"
#}
#SSH Private Key
#variable "ssh-private-key-for-ec2" {
#  default = "../credcomp"
#}
#Stack Name
variable "stack-name" {
  default = "prismacloud-credential-compromise"
}
#Scenario Name
variable "scenario-name" {
  default = "prismacloud-credential-compromise-ec2-ssrf"
}
#s3 bucket to simulate attack
resource "random_id" "id" {
    byte_length = 8
}
variable "credcomp-s3-bucket" {
  default = "$(random_id.id.hex)-credcomp-test-bucket"
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
