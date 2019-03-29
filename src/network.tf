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

resource "aws_subnet" "step-subnet-1a" {
  vpc_id     = "${var.vpc_id}"
  cidr_block = "172.31.32.0/20"


  availability_zone = "ap-northeast-1a"

  tags = {
    Name = "${terraform.workspace}-step-subnet-1a"
  }
}