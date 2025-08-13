# Terraform EC2 Instance with Key Pair

This Terraform configuration creates an AWS EC2 instance with an associated key pair, security group, and basic setup.

## Resources Created

- **EC2 Instance**: Amazon Linux 2023 instance with configurable type
- **Key Pair**: AWS key pair for SSH access
- **Security Group**: Allows SSH (22), HTTP (80), and HTTPS (443) access
- **User Data Script**: Installs useful packages and sets up the instance

## Prerequisites

1. **AWS CLI configured** with appropriate credentials
2. **Terraform installed** (version >= 1.0)
3. **SSH key pair generated** on your local machine

### Generate SSH Key Pair (if you don't have one)

```bash
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
```

This will create `~/.ssh/id_rsa` (private key) and `~/.ssh/id_rsa.pub` (public key).

## Usage

1. **Clone or download** this configuration to your local machine

2. **Copy the example variables file**:
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```

3. **Edit terraform.tfvars** with your desired values:
   ```hcl
   aws_region      = "us-east-1"
   key_pair_name   = "my-ec2-keypair"
   public_key_path = "~/.ssh/id_rsa.pub"
   instance_name   = "my-ec2-instance"
   instance_type   = "t3.micro"
   environment     = "dev"
   ```

4. **Initialize Terraform**:
   ```bash
   terraform init
   ```

5. **Plan the deployment**:
   ```bash
   terraform plan
   ```

6. **Apply the configuration**:
   ```bash
   terraform apply
   ```

7. **Connect to your instance**:
   ```bash
   ssh -i ~/.ssh/id_rsa ec2-user@<public_ip>
   ```
   (The exact command will be shown in the Terraform outputs)

## Configuration Options

| Variable | Description | Default | Required |
|----------|-------------|---------|----------|
| `aws_region` | AWS region for resources | `us-east-1` | No |
| `key_pair_name` | Name for the key pair | `my-ec2-keypair` | No |
| `public_key_path` | Path to public key file | `~/.ssh/id_rsa.pub` | No |
| `instance_name` | Name tag for EC2 instance | `my-ec2-instance` | No |
| `instance_type` | EC2 instance type | `t3.micro` | No |
| `root_volume_type` | Root volume type | `gp3` | No |
| `root_volume_size` | Root volume size (GB) | `20` | No |
| `enable_monitoring` | Enable detailed monitoring | `false` | No |
| `enable_termination_protection` | Prevent accidental termination | `false` | No |
| `environment` | Environment tag | `dev` | No |
| `project_name` | Project name tag | `terraform-ec2` | No |

## Outputs

After successful deployment, Terraform will display:

- Instance ID
- Public and private IP addresses
- Public DNS name
- SSH connection command
- Security group ID
- Key pair information

## Security Considerations

- The security group allows SSH access from anywhere (0.0.0.0/0). Consider restricting this to your IP address for better security.
- Root volume is encrypted by default
- Consider enabling termination protection for production instances

## Cleanup

To destroy the created resources:

```bash
terraform destroy
```

## File Structure

```
.
├── main.tf                    # Main Terraform configuration
├── variables.tf               # Variable definitions
├── outputs.tf                 # Output definitions
├── user_data.sh              # Instance initialization script
├── terraform.tfvars.example  # Example variables file
└── README.md                 # This file
```

## Troubleshooting

1. **Permission denied (publickey)**: Ensure your private key has correct permissions:
   ```bash
   chmod 600 ~/.ssh/id_rsa
   ```

2. **Key pair already exists**: If you get an error about the key pair existing, either:
   - Use a different `key_pair_name` in terraform.tfvars
   - Delete the existing key pair from AWS Console

3. **Instance not accessible**: Check that your security group rules allow SSH access from your IP address.

## Cost Estimation

- **t3.micro**: ~$8.50/month (eligible for AWS Free Tier)
- **gp3 20GB**: ~$1.60/month
- **Data transfer**: Varies based on usage

Remember to stop or terminate instances when not in use to avoid charges.
