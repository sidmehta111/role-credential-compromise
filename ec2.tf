#Iam Role Policy
resource "aws_iam_policy" "credcomp-ec2-role-policy" {
  name = "PrismaCloud-credcomp-ec2-role-policy-${random_string.random_suffix.id}"
  description = "credcomp-ec2-role-policy-${random_string.random_suffix.id}"
  policy = jsonencode({
      "Version": "2012-10-17",
      "Statement": [
          {
              "Sid": "VisualEditor0",
              "Effect": "Allow",
              "Action": [
                  "s3:*",
                  "cloudwatch:*"
              ],
              "Resource": "*"
          }
      ]
  })
}
#IAM Role
resource "aws_iam_role" "credcomp-ec2-role" {
  name = "PrismaCloud-credcomp-ec2-role-${random_string.random_suffix.id}"
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "ec2.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
      }
    ]
  })
  tags = {
      Name = "credcomp-ec2-role-${random_string.random_suffix.id}"
      Stack = var.stack-name
      Scenario = var.scenario-name
  }
}
#IAM Role Policy Attachment
resource "aws_iam_policy_attachment" "credcomp-ec2-role-policy-attachment" {
  name = "credcomp-ec2-role-policy-attachment-${random_string.random_suffix.id}"
  roles = [
      aws_iam_role.credcomp-ec2-role.name
  ]
  policy_arn = aws_iam_policy.credcomp-ec2-role-policy.arn
}
#IAM Instance Profile
resource "aws_iam_instance_profile" "credcomp-ec2-instance-profile" {
  name = "PrismaCloud-credcomp-ec2-instance-profile-${random_string.random_suffix.id}"
  role = aws_iam_role.credcomp-ec2-role.name
}
data "external" "current_ip" {
  program = ["bash", "-c", "curl -s 'https://api.ipify.org?format=json'"]
}
#Security Groups
resource "aws_security_group" "credcomp-ec2-ssh-security-group" {
  name = "PrismaCloud-credcomp-ec2-ssh-${random_string.random_suffix.id}"
  description = "Credential compromise ${random_string.random_suffix.id} Security Group for EC2 Instance over SSH"
  vpc_id = aws_vpc.credcomp-vpc.id
  ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["${data.external.current_ip.result.ip}/32"]
  }
  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = [
          "0.0.0.0/0"
      ]
  }
  tags = {
    Name = "PrismaCloud-credcomp-ec2-ssh-${random_string.random_suffix.id}"
    Stack = var.stack-name
    Scenario = var.scenario-name
  }
}
resource "aws_security_group" "credcomp-ec2-http-security-group" {
  name = "PrismaCloud-credcomp-ec2-http-${random_string.random_suffix.id}"
  description = "Credential compromise ${random_string.random_suffix.id} Security Group for EC2 Instance over HTTP"
  vpc_id = aws_vpc.credcomp-vpc.id
  ingress {
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = ["${data.external.current_ip.result.ip}/32"]
  }
  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = [
          "0.0.0.0/0"
      ]
  }
  tags = {
    Name = "PrismaCloud-credcomp-ec2-http-${random_string.random_suffix.id}"
    Stack = var.stack-name
    Scenario = var.scenario-name
  }
}
data "aws_ami" "ubuntu" {
    most_recent = true
    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
    }
    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }
}
#EC2 Instance
resource "aws_instance" "credcomp-ubuntu-ec2" {
    ami = "${data.aws_ami.ubuntu.id}"
    instance_type = "t2.micro"
    iam_instance_profile = aws_iam_instance_profile.credcomp-ec2-instance-profile.name
    subnet_id = aws_subnet.credcomp-public-subnet-1.id
    vpc_security_group_ids = [
        aws_security_group.credcomp-ec2-ssh-security-group.id,
        aws_security_group.credcomp-ec2-http-security-group.id
    ]
    root_block_device {
        volume_type = "gp2"
        volume_size = 8
        delete_on_termination = true
    }
    user_data = <<-EOF
        #!/bin/bash
        apt-get update
        curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
        DEBIAN_FRONTEND=noninteractive apt-get -y install nodejs unzip
        npm install http express needle command-line-args
        cd /home/ubuntu
        mkdir app
        cd app
        curl https://raw.githubusercontent.com/sethsec/Nodejs-SSRF-App/master/ssrf-demo-app.js -s -o ssrf-demo-app.js
        sudo node ssrf-demo-app.js &
        echo -e "\n* * * * * root node /home/ubuntu/app/ssrf-demo-app.js &\n* * * * * root sleep 10; node /home/ubuntu/app/ssrf-demo-app.js &\n* * * * * root sleep 20; node /home/ubuntu/app/ssrf-demo-app.js &\n* * * * * root sleep 30; node /home/ubuntu/app/ssrf-demo-app.js &\n* * * * * root sleep 40; node /home/ubuntu/app/ssrf-demo-app.js &\n* * * * * root sleep 50; node /home/ubuntu/app/ssrf-demo-app.js &\n" >> /etc/crontab
        cd /home/ubuntu
        curl https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -s -o awscliv2.zip
        unzip awscliv2.zip
        sudo ./aws/install
        echo "test" > critical.txt
        aws s3api put-object --bucket ${aws_s3_bucket.credcomp.bucket} --key critical.txt --body critical.txt
        aws s3api put-bucket-versioning --bucket ${aws_s3_bucket.credcomp.bucket} --versioning-configuration Status=Enabled
        EOF
    volume_tags = {
        Name = "Credential compromise ${random_string.random_suffix.id} EC2 Instance Root Device"
        Stack = var.stack-name
        Scenario = var.scenario-name
    }
    tags = {
        Name = "credcomp-ubuntu-ec2-${random_string.random_suffix.id}"
        Stack = var.stack-name
        Scenario = var.scenario-name
    }
}
# resource block for eip #
resource "aws_eip" "credcomp-ec2-eip" {
  instance = aws_instance.credcomp-ubuntu-ec2.id
  vpc = true
}