

 # Create a Null Resource and Provisioners
resource "null_resource" "name" {
  depends_on = [module.ec2_public]

  # Connection Block for Provisioners to connect to Bastion Host
  connection {
    type        = "ssh"
    host        = aws_eip.public_instance_eip.public_ip
    user        = "ubuntu"
    private_key = file("private-key/310.pem")
  }

  # File Provisioner: Copies the terraform-key.pem file to /tmp/310.pem on Bastion Host
  provisioner "file" {
    source      = "private-key/310.pem"
    destination = "/tmp/310.pem"
  }

  # Remote Exec Provisioner: Using remote-exec provisioner, fix the private key permissions on Bastion Host
  provisioner "remote-exec" {
    inline = [
      "sudo chmod 400 /tmp/310.pem"
    ]
  }

  # Install Docker and Docker Compose on the private EC2 instances via Bastion Host
  provisioner "remote-exec" {
    when    = create
    inline = [
      "sudo ssh -o 'StrictHostKeyChecking no' -i /tmp/310.pem ubuntu@${module.ec2_private[0].private_ip} 'sudo apt update -y'",
      "sudo ssh -o 'StrictHostKeyChecking no' -i /tmp/310.pem ubuntu@${module.ec2_private[0].private_ip}  'git clone https://github.com/MUKIT22/vprofile-project'",

      "sudo ssh -o 'StrictHostKeyChecking no' -i /tmp/310.pem ubuntu@${module.ec2_private[0].private_ip}  'sudo apt install docker.io -y'",
      "sudo ssh -o 'StrictHostKeyChecking no' -i /tmp/310.pem ubuntu@${module.ec2_private[0].private_ip}  'sudo apt install python3-pip -y'",
      "sudo ssh -o 'StrictHostKeyChecking no' -i /tmp/310.pem ubuntu@${module.ec2_private[0].private_ip}  'sudo curl -L 'https://github.com/docker/compose/releases/download/v2.3.3/docker-compose-Linux-x86_64' -o /usr/local/bin/docker-compose'",
      "sudo ssh -o 'StrictHostKeyChecking no' -i /tmp/310.pem ubuntu@${module.ec2_private[0].private_ip}  'sudo chmod +x /usr/local/bin/docker-compose'",
      "sudo ssh -o 'StrictHostKeyChecking no' -i /tmp/310.pem ubuntu@${module.ec2_private[0].private_ip}  'sudo apt install docker-compose -y'",
      "sudo ssh -o 'StrictHostKeyChecking no' -i /tmp/310.pem ubuntu@${module.ec2_private[0].private_ip}  'cd vprofile-project && sudo git checkout containers && sudo docker-compose up -d'",

      "sudo ssh -o 'StrictHostKeyChecking no' -i /tmp/310.pem ubuntu@${module.ec2_private[1].private_ip} 'sudo apt update -y'",
      "sudo ssh -o 'StrictHostKeyChecking no' -i /tmp/310.pem ubuntu@${module.ec2_private[1].private_ip}  'git clone https://github.com/MUKIT22/vprofile-project'",

      "sudo ssh -o 'StrictHostKeyChecking no' -i /tmp/310.pem ubuntu@${module.ec2_private[1].private_ip}  'sudo apt install docker.io -y'",
      "sudo ssh -o 'StrictHostKeyChecking no' -i /tmp/310.pem ubuntu@${module.ec2_private[1].private_ip}  'sudo apt install python3-pip -y'",
      "sudo ssh -o 'StrictHostKeyChecking no' -i /tmp/310.pem ubuntu@${module.ec2_private[1].private_ip}  'sudo curl -L 'https://github.com/docker/compose/releases/download/v2.3.3/docker-compose-Linux-x86_64' -o /usr/local/bin/docker-compose'",
      "sudo ssh -o 'StrictHostKeyChecking no' -i /tmp/310.pem ubuntu@${module.ec2_private[1].private_ip}  'sudo chmod +x /usr/local/bin/docker-compose'",
      "sudo ssh -o 'StrictHostKeyChecking no' -i /tmp/310.pem ubuntu@${module.ec2_private[1].private_ip}  'sudo apt install docker-compose -y'",
      "sudo ssh -o 'StrictHostKeyChecking no' -i /tmp/310.pem ubuntu@${module.ec2_private[1].private_ip}  'cd vprofile-project && sudo git checkout containers && sudo docker-compose up -d'",

    ]
  }
}


