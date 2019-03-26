terraform {
    required_version = ">= 0.11.0"
    backend "s3" {
        bucket = "cabos-tfstate"
        region = "ap-northeast-1"
        key = "terraform.tfstate"
        encrypt = true
    }
}

provider "aws" {
    region = "ap-northeast-1"
}
