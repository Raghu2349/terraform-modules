resource "aws_vpc" "vpc" {
    cidr_block = "${var.vpc_cidr}"

    tags {
        Name = "${var.projectName} ${var.environment} VPC"
        Environment="${var.environment}"
    }
}

data "aws_availability_zones" "available" {}




resource "aws_subnet" "public" {
  count       = "${length(var.subnet_cidrs_public)}"
  vpc_id      = "${aws_vpc.vpc.id}"
  cidr_block  = "${var.subnet_cidrs_public[count.index]}"
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"

  tags {

        Name = "${var.projectName} ${var.environment} Subnet_${count.index}"
        Environment="${var.environment}"
  }
}



resource "aws_internet_gateway" "default" {
    vpc_id = "${aws_vpc.vpc.id}"

    tags{

       		Name = "${var.projectName} ${var.environment} IGW"
        	Environment="${var.environment}"
    }
}



resource "aws_route_table" "routetable" {
    vpc_id = "${aws_vpc.vpc.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.default.id}"
    }

    tags {

         Name = "${var.projectName} ${var.environment} RouteTable"
         Environment="${var.environment}"
    }
}

resource "aws_route_table_association" "publicroutetableassn" {
  count = "${length(var.subnet_cidrs_public)}"

  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${aws_route_table.routetable.id}"
}
