#Always output the AWS Account ID
output "credcomp_output_aws_account_id" {
  description = "Cloud account ID"
  value = data.aws_caller_identity.aws-account-id.account_id
}
output "public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_eip.credcomp-ec2-eip.public_ip
}