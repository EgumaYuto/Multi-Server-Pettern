## instance
resource "aws_instance" "app1" {
    ami = "ami-0f9ae750e8274075b"
    instance_type = "t2.micro"

    ## TODO remove this
    key_name = "myFirstKey"

    security_groups = [
        "${aws_security_group.allow-from-elb-and-ssh.id}",
    ]
    subnet_id = "${aws_subnet.app-subnet-1a.id}"

    associate_public_ip_address = true

    tags = {
        Name = "${terraform.workspace}-app1"
    }
}

resource "aws_instance" "app2" {
    ami = "ami-0f9ae750e8274075b"
    instance_type = "t2.micro"

    ## TODO remove this
    key_name = "myFirstKey"

    security_groups = [
        "${aws_security_group.allow-from-elb-and-ssh.id}",
    ]
    subnet_id = "${aws_subnet.app-subnet-1c.id}"

    associate_public_ip_address = true

    tags = {
        Name = "${terraform.workspace}-app2"
    }
}

## load balancer
resource "aws_elb" "app-elb" {
    name = "app-elb"
    subnets = ["${aws_subnet.app-subnet-1a.id}", "${aws_subnet.app-subnet-1c.id}"]

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
    vpc_id = "${var.vpc_id}"

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
        cidr_blocks = ["${var.vpc_cidr_block}"]
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

resource "aws_security_group" "allow-all-access" {
    name = "${terraform.workspace}-allow-all-access"
    description = "allow from elb and ssh for ${terraform.workspace}"
    vpc_id = "${var.vpc_id}"

    ## for elb
    ingress {
        from_port = 0
        to_port = 65535
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 0
        to_port = 65535
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
        Name = "${terraform.workspace}-allow-all-access"
    }
}

