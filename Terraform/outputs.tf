# EC2 Instance Outputs
output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.main.id
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.main.public_ip
}

output "instance_private_ip" {
  description = "Private IP address of the EC2 instance"
  value       = aws_instance.main.private_ip
}

output "instance_public_dns" {
  description = "Public DNS name of the EC2 instance"
  value       = aws_instance.main.public_dns
}

output "instance_state" {
  description = "State of the EC2 instance"
  value       = aws_instance.main.instance_state
}

# Key Pair Outputs
output "key_pair_name" {
  description = "Name of the created key pair"
  value       = aws_key_pair.main.key_name
}

output "key_pair_fingerprint" {
  description = "SHA-1 digest of the DER encoded public key"
  value       = aws_key_pair.main.fingerprint
}

# Security Group Outputs
output "security_group_id" {
  description = "ID of the security group"
  value       = aws_security_group.ec2_sg.id
}

output "security_group_name" {
  description = "Name of the security group"
  value       = aws_security_group.ec2_sg.name
}

# AMI Information
output "ami_id" {
  description = "AMI ID used for the instance"
  value       = data.aws_ami.ubuntu.id
}

output "ami_description" {
  description = "Description of the AMI used"
  value       = data.aws_ami.ubuntu.description
}

# Connection Information
output "ssh_connection_command" {
  description = "SSH command to connect to the instance"
  value       = "ssh -i ~/.ssh/My-server ubuntu@${aws_instance.main.public_ip}"
}
