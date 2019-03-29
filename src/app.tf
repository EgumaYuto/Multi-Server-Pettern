#################
## subnet
#################
resource "aws_subnet" "app-subnet-1a" {
  vpc_id     = "${var.vpc_id}"
  cidr_block = "172.31.0.0/20"

  availability_zone = "ap-northeast-1a"

  tags = {
    Name = "${terraform.workspace}-app-subnet-1a"
  }
}

resource "aws_subnet" "app-subnet-1c" {
  vpc_id     = "${var.vpc_id}"
  cidr_block = "172.31.16.0/20"

  availability_zone = "ap-northeast-1c"

  tags = {
    Name = "${terraform.workspace}-app-subnet-1c"
  }
}

#################
## instance
#################
resource "aws_instance" "app1" {
    ami = "ami-0f9ae750e8274075b"
    instance_type = "t2.micro"

    key_name = "myFirstKey"

    security_groups = [
        "${aws_security_group.allow-from-elb-and-step.id}",
    ]
    subnet_id = "${aws_subnet.app-subnet-1a.id}"

    tags = {
        Name = "${terraform.workspace}-app1"
    }
}

resource "aws_instance" "app2" {
    ami = "ami-0f9ae750e8274075b"
    instance_type = "t2.micro"

    key_name = "myFirstKey"

    security_groups = [
        "${aws_security_group.allow-from-elb-and-step.id}",
    ]
    subnet_id = "${aws_subnet.app-subnet-1c.id}"

    tags = {
        Name = "${terraform.workspace}-app2"
    }
}

#################
## security group
#################
resource "aws_security_group" "allow-from-elb-and-step" {
    name = "${terraform.workspace}-allow-from-elb-and-step"
    description = "allow from elb and step for ${terraform.workspace}"
    vpc_id = "${var.vpc_id}"

    ## for ssh
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["${aws_subnet.step-subnet-1a.cidr_block}"]
    }

    ## for elb
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["${var.vpc_cidr_block}"]
    }

    egress {
        from_port       = 0
        to_port         = 0
        protocol        = "-1"
        cidr_blocks     = ["0.0.0.0/0"]
    }

    tags = {
        Name = "${terraform.workspace}-allow-from-elb-and-step"
    }
}

