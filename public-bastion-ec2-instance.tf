module "ec2_public" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.5.0"
  # insert the 10 required variables here
  name                   = "${var.environment}-public-ec2"
  count         = 1
  ami                    = "ami-0261755bbcb8c4a84"
  instance_type          = var.instance_type
  key_name               = var.instance_keypair
  #monitoring             = true
  subnet_id = element(module.vpc.public_subnets, 1)

  vpc_security_group_ids = [module.public_sg.security_group_id]
}
