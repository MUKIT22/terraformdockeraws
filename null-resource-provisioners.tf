

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
      "sudo ssh -o 'StrictHostKeyChecking no' -i /tmp/219.pem ubuntu@${module.ec2_private[0].private_ip} 'sudo touch rtyu.txt'",

      # Define the GitHub repo URL and the project directory name
      "REPO_URL='https://github.com/MUKIT22/vprofile-project'",

      # Clone the repo using git clone command
      "sudo git clone $REPO_URL",

      # Change directory to the project directory using cd command
      "cd vprofile-project",

      "sudo git checkout containers",

      # Install required packages
      "yes |sudo apt-get install -y ca-certificates curl gnupg",

      # Create directory for apt keyrings
      "yes |sudo install -m 0755 -d /etc/apt/keyrings",

      # Download Docker GPG key
      "curl -fsSL https://download.docker.com/linux/ubuntu/gpg |yes | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg",

      # Set permissions for the GPG key
      "yes |sudo chmod a+r /etc/apt/keyrings/docker.gpg",

      # Add the Docker repository to Apt sources
      "echo \"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo $VERSION_CODENAME) stable\" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null",

      # Update Apt package lists
      "sudo apt-get update -y",

      # Install Docker and related packages
      "sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin",

      # Run docker compose up using docker-compose command
      "sudo docker-compose up -d",
      
      
      # Repeat the same commands for the second private instance
      "sudo ssh -o 'StrictHostKeyChecking no' -i /tmp/219.pem ubuntu@${module.ec2_private[1].private_ip} 'sudo touch rtyu.txt'",
            # Define the GitHub repo URL and the project directory name
      "REPO_URL='https://github.com/MUKIT22/vprofile-project'",
      
      # Clone the repo using git clone command
      "sudo git clone $REPO_URL",
      
      # Change directory to the project directory using cd command
      "cd vprofile-project",
      
      "sudo git checkout containers",
            # Install required packages
      "sudo apt-get install -y ca-certificates curl gnupg",

      # Create directory for apt keyrings
      "sudo install -m 0755 -d /etc/apt/keyrings",

      # Download Docker GPG key
      "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg",

      # Set permissions for the GPG key
      "sudo chmod a+r /etc/apt/keyrings/docker.gpg",

      # Add the Docker repository to Apt sources
      "echo \"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo $VERSION_CODENAME) stable\" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null",

      # Update Apt package lists
      "sudo apt-get update -y",

      # Install Docker and related packages
      "sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin",

      # Run docker compose up using docker-compose command
      "sudo docker-compose up -d"
    ]
  }
}

