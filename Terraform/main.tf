# Configure the AWS Provider
terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Create a key pair
resource "aws_key_pair" "main" {
  key_name   = var.key_pair_name
  public_key = file(var.public_key_path)

  tags = {
    Name        = var.key_pair_name
    Environment = var.environment
  }
}

# Use specific Ubuntu 24.04 LTS AMI for us-east-1
data "aws_ami" "ubuntu" {
  most_recent = false
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "image-id"
    values = ["ami-020cba7c55df1f615"] # Ubuntu 24.04 LTS in us-east-1
  }
}

# Create a security group
resource "aws_security_group" "ec2_sg" {
  name        = "My-server-Sg"
  description = "Security group for EC2 instance"

  # SSH access
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP access
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS access
  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # All outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

# Create EC2 instance
resource "aws_instance" "main" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name      = aws_key_pair.main.key_name

  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  # Enable detailed monitoring
  monitoring = var.enable_monitoring

  # Root block device configuration
  root_block_device {
    volume_type           = var.root_volume_type
    volume_size           = var.root_volume_size
    delete_on_termination = true
    encrypted             = true

    tags = {
      Name        = "${var.instance_name}-root-volume"
      Environment = var.environment
    }
  }

  tags = {
    Name        = var.instance_name
    Environment = var.environment
    Project     = var.project_name
  }

  # Prevent accidental termination
  disable_api_termination = var.enable_termination_protection
}



