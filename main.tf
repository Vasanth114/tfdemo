provider "aws" {
  region = "us-west-1"
}

resource "aws_instance" "example" {
  ami           = "ami-04fdea8e25817cd69"  # Amazon Linux 2 AMI
  instance_type = "t2.micro"
  key_name      = "tfcloud"

  provisioner "local-exec" {
    command = "echo Instance ID: ${self.id} > instance_id.txt"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum install -y httpd",
      "sudo systemctl start httpd",
      "sudo systemctl enable httpd"
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("tfcloud.pem")
      host        = self.public_ip
    }
  }

  tags = {
    Name = "TerraformcloudExample"
  }
}

output "instance_public_ip" {
  description = "The public IP address of the created EC2 instance"
  value       = aws_instance.example.public_ip
}
