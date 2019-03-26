## instance
resource "aws_instance" "app1" {
    ami = "ami-0f9ae750e8274075b"
    instance_type = "t2.micro"

    ## TODO remove this
    key_name = "myFirstKey"

    availability_zone="ap-northeast-1a"

    tags = {
        Name = "${terraform.workspace}-app1"
    }
}

resource "aws_instance" "app2" {
    ami = "ami-0f9ae750e8274075b"
    instance_type = "t2.micro"

    ## TODO remove this
    key_name = "myFirstKey"

    availability_zone="ap-northeast-1a"

    tags = {
        Name = "${terraform.workspace}-app2"
    }
}

## load balancer
resource "aws_elb" "app-elb" {
    name = "app-elb"
    availability_zones = ["ap-northeast-1a","ap-northeast-1c","ap-northeast-1d"]

    listener {
        instance_port     = 80
        instance_protocol = "http"
        lb_port           = 80
        lb_protocol       = "http"
    }

    health_check {
        healthy_threshold   = 2
        unhealthy_threshold = 2
        timeout             = 3
        target              = "HTTP:80/"
        interval            = 30
    }

    instances = ["${aws_instance.app1.id}", "${aws_instance.app2.id}"]
    cross_zone_load_balancing   = true
    idle_timeout                = 400
    connection_draining         = true
    connection_draining_timeout = 400

    tags = {
       Name = "${terraform.workspace}-app-elb"
    }
}

## security group
resource "aws_security_group" "allow-from-elb-and-ssh" {
    name = "${terraform.workspace}-allow-from-elb-and-ssh"
    description = "allow from elb and ssh for ${terraform.workspace}"
    vpc_id = "${aws_vpc.vpc.id}"

    ## for ssh
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ## for elb
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["${aws_vpc.vpc.cidr_block}"]
    }

    egress {
        from_port       = 0
        to_port         = 0
        protocol        = "-1"
        cidr_blocks     = ["0.0.0.0/0"]
    }

    tags = {
        Name = "${terraform.workspace}-allow-from-elb-and-ssh"
    }
}
