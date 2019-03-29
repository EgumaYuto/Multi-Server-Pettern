resource "aws_subnet" "step-subnet-1a" {
  vpc_id     = "${var.vpc_id}"
  cidr_block = "172.31.32.0/20"


  availability_zone = "ap-northeast-1a"

  tags = {
    Name = "${terraform.workspace}-step-subnet-1a"
  }
}

resource "aws_instance" "step1" {
  ami = "ami-0f9ae750e8274075b"
  instance_type = "t2.micro"

  key_name = "myFirstKey"

  security_groups = [
    "${aws_security_group.allow-from-all-ssh-access.id}",
  ]
  subnet_id = "${aws_subnet.app-subnet-1a.id}"

  associate_public_ip_address = true

  tags = {
    Name = "${terraform.workspace}-step"
  }
}

resource "aws_security_group" "allow-from-all-ssh-access" {
  name = "${terraform.workspace}-allow-from-all-ssh-access"
  description = "allow from all ssh access for ${terraform.workspace}"
  vpc_id = "${var.vpc_id}"

  ## for ssh
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${terraform.workspace}-allow-from-all-ssh-access"
  }
}