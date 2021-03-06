provider "aws" {
  region                  = "ap-south-1"
  profile                 = "akhil"
}

resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

resource "aws_default_subnet" "default_az1" {
  availability_zone = "ap-south-1a"
  tags = {
    Name = "Default subnet"
  }
}

resource "aws_security_group" "secure" {
  name        = "secure"
  description = "Allow HTTP, SSH inbound traffic"
  vpc_id      = aws_default_vpc.default.id

  ingress {
    description = "http"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "ssh"
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
    Name = "security-wizard"
  }
}

resource "aws_instance" "task19m" {
  ami           = "ami-026f33d38b6410e30"
  instance_type = "t2.micro"
  key_name = "key123"
  user_data = "fd50d738924f03fa08bbabe03058dcdcd20d0986"
  security_groups = [ "${aws_security_group.secure.name}" ]
  tags = {
    Name = "Master"
  }
}

resource "aws_instance" "task19s" {
  ami = "ami-026f33d38b6410e30"
  instance_type = "t2.micro"
  key_name = "key123"
  #count = 1
  user_data = "fd50d738924f03fa08bbabe03058dcdcd20d0986"
  security_groups = [ "${aws_security_group.secure.name}" ]
  tags = {
    Name = "Slaves"
  }
}

# # Creating a Local file, which contains Public IP's of our Cluster INstanc`es
# resource "local_file" "ipfile" {
#     content = "Master_Instance_Public_IP => ${aws_instance.task19m.public_ip}\n Slave_Instance1_Public_IP ${aws_instance.task19s[1].public_ip} \n Slave_Instance2_Public_IP ${aws_instance.task19s[2].public_ip} \n Slave_Instance3_Public_IP ${aws_instance.task19s[3].public_ip}"
#     filename = "details"
# }


# Creating a Local file, which contains Public IP's of our Cluster INstanc`es
resource "local_file" "ipfile" {
    content = "Master_Instance_Public_IP => ${aws_instance.task19m.public_ip}\nSlave_Instance1_Public_IP => ${aws_instance.task19s.public_ip}"
    filename = "details"
}
