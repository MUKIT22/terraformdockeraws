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
 subnet_id = module.vpc.public_subnets[count.index]


  vpc_security_group_ids = [module.private_sg.security_group_id]
   user_data = <<-EOF
                #!/bin/bash
                # Add Docker's official GPG key:
                sudo apt-get update
                sudo apt-get install ca-certificates curl gnupg
                sudo install -m 0755 -d /etc/apt/keyrings
                curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
                sudo chmod a+r /etc/apt/keyrings/docker.gpg

                # Add the repository to Apt sources:
                echo \
                  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
                  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
                  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
                sudo apt-get update

                sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
                EOF

}
