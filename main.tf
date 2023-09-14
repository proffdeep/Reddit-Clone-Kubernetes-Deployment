provider "aws" {}


resource "aws_security_group" "allow_ssh" {
  vpc_id = "vpc-04999e39337e311bb"  # Replace with your VPC ID

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "CI-Server" {
  ami           = "ami-053b0d53c279acc90"
  instance_type = "t2.micro"
  subnet_id     = "subnet-0bf3cade6e9ea7dda"
  key_name      = "EC2 Tutorial"

  vpc_security_group_ids = [aws_security_group.allow_ssh.id] # Reference to the security group below

  user_data = <<-EOF
    #!/bin/bash
    echo "ClientAliveInterval 120" >> /etc/ssh/sshd_config
    echo "ClientAliveCountMax 10" >> /etc/ssh/sshd_config
    systemctl restart sshd
    EOF

  tags = {
    Name = "CI"
  }
}

resource "aws_instance" "CD-Server" {
  ami           = "ami-053b0d53c279acc90"
  instance_type = "t2.large"
  subnet_id     = "subnet-0bf3cade6e9ea7dda"
  key_name      = "EC2 Tutorial"

  vpc_security_group_ids = [aws_security_group.allow_ssh.id] # Reference to the security group below

  user_data = <<-EOF
    #!/bin/bash
    echo "ClientAliveInterval 120" >> /etc/ssh/sshd_config
    echo "ClientAliveCountMax 10" >> /etc/ssh/sshd_config
    systemctl restart sshd
    EOF

  tags = {
    Name = "CD"
  }
}

