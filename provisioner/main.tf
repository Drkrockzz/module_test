resource "aws_key_pair" "virginia_key" {
  key_name = "virginia_linux"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_vpc" "provision" {
  cidr_block = "192.130.0.0/20"
}

resource "aws_subnet" "sub-1a" {
  vpc_id = aws_vpc.provision.id
  cidr_block = "192.130.4.0/22"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "ig-1" {
  vpc_id = aws_vpc.provision.id
}

resource "aws_route_table" "sub_public" {
  vpc_id = aws_vpc.provision.id

  route  {
    cidr_block = "192.130.0.0/20"
    gateway_id = "local"
  }

  route  {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ig-1.id
  }
}

resource "aws_route_table_association" "associate" {
  subnet_id = aws_subnet.sub-1a.id
  route_table_id = aws_route_table.sub_public.id
}

resource "aws_security_group" "prov_sg" {
    name = "web"
    vpc_id = aws_vpc.provision.id

    ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    }
  
   egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Web-sg"
  }
}

resource "aws_instance" "ec2_provi" {
    ami ="ami-05b10e08d247fb927" 
    instance_type = "t2.micro"
    key_name = aws_key_pair.virginia_key.key_name
    vpc_security_group_ids = [aws_security_group.prov_sg.id]
    subnet_id = aws_subnet.sub-1a.id

    connection {
    type        = "ssh"
    user        = "ec2-user"  # Replace with the appropriate username for your EC2 instance
    private_key = file("~/.ssh/id_rsa")  # Replace with the path to your private key
    host        = self.public_ip
  }
    provisioner "file" {
    source      = "/root/app.py"  # Replace with the path to your local file
    destination = "/home/ec2-user/app.py"  # Replace with the path on the remote instance
    }

    provisioner "remote-exec" {
     inline = [
      "echo 'Hello from the remote instance'",
      "sudo yum update -y",  # Update package lists (for ubuntu)
      "sudo yum install -y python3-pip",  # Example package installation
      "cd /home/ubuntu",
      "sudo pip3 install flask",
      "sudo python3 /home/ec2-user/app.py >> log 2>&1 &",
    ]
    }
}


