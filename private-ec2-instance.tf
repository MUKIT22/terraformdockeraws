module "ec2_private" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  depends_on = [ module.vpc ] 
  version = "5.5.0"
  # insert the 10 required variables here
  name                   = "${var.environment}-private-ec2"
  count                  = 2
  ami                    = "ami-0261755bbcb8c4a84"
  instance_type          = var.instance_type
  key_name               = var.instance_keypair
  #monitoring             = true
 subnet_id = module.vpc.private_subnets[count.index]


  vpc_security_group_ids = [module.private_sg.security_group_id]
  user_data = <<-EOT
                #!/bin/bash
                

                
                EOT

}
