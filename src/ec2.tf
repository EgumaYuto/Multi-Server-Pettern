## application
resource "aws_instance" "app1" {
    ami = "ami-0f9ae750e8274075b"
    instance_type = "t2.micro"

    ## TODO remove this
    key_name = "myFirstKey"

    tags = {
        Name = "${terraform.workspace}-app1"
    }
}

resource "aws_instance" "app2" {
    ami = "ami-0f9ae750e8274075b"
    instance_type = "t2.micro"

    ## TODO remove this
    key_name = "myFirstKey"

    tags = {
        Name = "${terraform.workspace}-app2"
    }
}
