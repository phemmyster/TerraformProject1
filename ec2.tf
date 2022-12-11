# variables
variable "vpc_cidr_blk" {}
variable "avail_zone" {}
variable "subnet_cidr_blk" {}
variable "env_prefix" {}


# create a provide
provider "aws" {
  region = "us-east-1" # i have created a default region
}

# create a vpc and a subnet inside the vpc
resource "aws_vpc" "myapp-vpc" {
  cidr_block = var.vpc_cidr_blk
  tags = {
    Name = "${var.env_prefix}-vpc"
  }
}

# create a subnet inside the vpc
resource "aws_subnet" "myapp-subnet" {
  vpc_id            = aws_vpc.myapp-vpc.id
  cidr_block        = var.subnet_cidr_blk
  availability_zone = var.avail_zone

  tags = {
    Name = "${var.env_prefix}-subnet-1"
  }

}


/* can also use use the default route table that was created 

# create a route-table > rtbl
resource "aws_route_table" "myapp-rtbl" {
  vpc_id = aws_vpc.myapp-vpc.id
  route {
    cidr_block = "0.0.0.0/0"

    gateway_id = aws_internet_gateway.myapp_igw.id #will have 2 create this resource
  }
  tags = {
    Name = "${var.env_prefix}-rtbl"
  }

}

# comment this out and do terraform apply  > to remove the route table
*/


# create an internet gateway  >> this need to be created 1st bt terraform can figure that out.
resource "aws_internet_gateway" "myapp_igw" {
  vpc_id = aws_vpc.myapp-vpc.id

  tags = {
    Name = "${var.env_prefix}-igw"
    # Name : "${var.env_prefix}-igw"
  }

}


/*

# want to associate subnet with the rout table that was created.

resource "aws_route_table_association" "myapp_rtbl_asso_subnet" {
    subnet_id = aws_subnet.myapp-subnet.id
    route_table_id = aws_route_table.myapp-rtbl.id

}
*/


## if we want to use the default route table 
## we comment out route-table and associate subnet

resource "aws_default_route_table" "default-rbt"{
    default_route_table_id = aws_vpc.myapp-vpc.default_route_table_id # to get this use terraform show aws_vpc.myapp-vpc to get d id
    route {
    cidr_block = "0.0.0.0/0"

    gateway_id = aws_internet_gateway.myapp_igw.id #will have 2 create this resource
  }
  tags = {
    Name = "${var.env_prefix}-default-rtbl"
  }

}

# create a fire wall rule