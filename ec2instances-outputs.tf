
output "ec2_public_instance_ids" {
  description = "List of IDs of instances"
  value       = join(", ", [for i in module.ec2_public : i.id])
}

## ec2_bastion_public_ip
output "ec2_public_ip" {
  description = "List of public IP addresses assigned to the instances"
  value       = join(", ", [for i in module.ec2_public : i.public_ip])
}

# Private EC2 Instances
## ec2_private_instance_ids
output "ec2_private_instance_ids" {
  description = "List of IDs of instances"
  value       = join(", ", [for i in module.ec2_private : i.id])
}
## ec2_private_ip
output "ec2_private_ip" {
  description = "List of private IP addresses assigned to the instances"
  value       = join(", ", [for i in module.ec2_private : i.private_ip])
}


