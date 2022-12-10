# variables
variable vpc_cidr_blk {}
variable avail_zone {}
variable subnet_cidr_blk {}
variable env_prefix {}


# create a provide
provider "aws"{
    region = "us-east-1" # i have created a default region
}

# create a vpc and a subnet inside the vpc
resource "aws_vpc" "myapp-vpc"{
    cidr_block = var.vpc_cidr_blk
    tags = {
        Name = "${var.env_prefix}-vpc"
    }
}

# create a subnet inside the vpc
resource "aws_subnet" "myapp-subnet"{
    vpc_id = aws_vpc.myapp-vpc.id 
    cidr_block = var.subnet_cidr_blk
    availability_zone = var.avail_zone
    tags = {
        Name = "${var.env_prefix}-subnet-1"
    }

}