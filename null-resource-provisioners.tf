

 # Create a Null Resource and Provisioners
resource "null_resource" "name" {
  depends_on = [module.ec2_public]

  # Connection Block for Provisioners to connect to Bastion Host
  connection {
    type        = "ssh"
    host        = aws_eip.public_instance_eip.public_ip
    user        = "ubuntu"
    private_key = file("private-key/219.pem")
  }

  # File Provisioner: Copies the terraform-key.pem file to /tmp/219.pem on Bastion Host
  provisioner "file" {
    source      = "private-key/219.pem"
    destination = "/tmp/219.pem"
  }

  # Remote Exec Provisioner: Using remote-exec provisioner, fix the private key permissions on Bastion Host
  provisioner "remote-exec" {
    inline = [
      "sudo chmod 400 /tmp/219.pem"
    ]
  }

  # Install Docker and Docker Compose on the private EC2 instances via Bastion Host
  provisioner "remote-exec" {
    when    = create
    inline = [
      # SSH into the first private instance via Bastion Host and execute Docker installation commands
      "sudo ssh -o 'StrictHostKeyChecking no' -i /tmp/219.pem ubuntu@${module.ec2_private[0].private_ip} 'sudo touch rtyu.txt'",
      
      
      # Repeat the same commands for the second private instance
      "sudo ssh -o 'StrictHostKeyChecking no' -i /tmp/219.pem ubuntu@${module.ec2_private[1].private_ip} 'sudo touch rtyu.txt'"
    ]
  }
}

