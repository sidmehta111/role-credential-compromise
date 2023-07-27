#VPCs
resource "aws_vpc" "credcomp-vpc" {
  cidr_block = "10.10.0.0/16"
  enable_dns_hostnames = true
  tags = {
      Name = "Credential compromise ${random_string.random_suffix.id} VPC"
      Stack = var.stack-name
      Scenario = var.scenario-name
  }
}
#Public Subnets
resource "aws_subnet" "credcomp-public-subnet-1" {
  availability_zone = "${var.region}a"
  cidr_block = "10.10.10.0/24"
  vpc_id = aws_vpc.credcomp-vpc.id
  tags = {
    Name = "Credential compromise ${random_string.random_suffix.id} Public Subnet #1"
    Stack = var.stack-name
    Scenario = var.scenario-name
  }
}
#Internet Gateway
resource "aws_internet_gateway" "credcomp-internet-gateway" {
  vpc_id = aws_vpc.credcomp-vpc.id
  tags = {
      Name = "Credential compromise ${random_string.random_suffix.id} Internet Gateway"
      Stack = var.stack-name
      Scenario = var.scenario-name
  }
}
#Public Subnet Routing Table
resource "aws_route_table" "credcomp-public-subnet-route-table" {
  vpc_id = aws_vpc.credcomp-vpc.id
  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.credcomp-internet-gateway.id
  }
  tags = {
      Name = "Credential compromise ${random_string.random_suffix.id} Route Table for Public Subnet"
      Stack = var.stack-name
      Scenario = var.scenario-name
  }
}
#Public Subnets Routing Associations
resource "aws_route_table_association" "credcomp-public-subnet-1-route-association" {
  subnet_id = aws_subnet.credcomp-public-subnet-1.id
  route_table_id = aws_route_table.credcomp-public-subnet-route-table.id
}