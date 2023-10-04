# Create Elastic IP for Bastion Host
# Resource - depends_on Meta-Argument
resource "aws_eip" "public_instance_eip" {
  depends_on = [ module.ec2_public, module.vpc ]
  instance = module.ec2_public[0].id
  domain   = "vpc"

## Local Exec Provisioner:  local-exec provisioner (Destroy-Time Provisioner - Triggered during deletion of Resource)
}