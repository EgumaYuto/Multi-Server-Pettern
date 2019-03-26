resource "aws_vpc" "vpc" {
    cidr_block = "172.31.0.0/20"
    instance_tenancy = "dedicated"
    tags = {
        Name = "${terraform.workspace}-vpc"
    }
}
