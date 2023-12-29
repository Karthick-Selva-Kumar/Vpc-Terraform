provider "aws" {
  region = "ap-south-1"
  profile = "default"
}


resource "aws_instance" "ec2-1" {
    ami = "ami-03f4878755434977f"
    instance_type = "t2.micro"
    key_name = "prd01"
   //vpc_security_group_ids = ["${aws_security_group.rtp03-sg.id}"]
   subnet_id = "${aws_subnet.rtp01-public_subent_01.id}"
}


resource "aws_instance" "ec2-2" {
    ami = "ami-0a0f1259dd1c90938"
    instance_type = "t2.micro"
    key_name = "prd01"
   //vpc_security_group_ids = ["${aws_security_group.rtp03-sg.id}"]
   subnet_id = "${aws_subnet.rtp02-public_subent_02.id}"
}


resource "aws_security_group" "rtp03-sg" {
    name = "rtp03-sg"
    vpc_id = "${aws_vpc.rtp03-vpc.id}"
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]

    }


 ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
 }


 ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]

    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "ssh-sg"

    }

}


//creating a VPC
resource "aws_vpc" "rtp03-vpc" {
    cidr_block = "10.1.0.0/16"
    tags = {
      Name = "rpt03-vpc"
    }

}

// Creating a Subnet
resource "aws_subnet" "rtp01-public_subent_01" {
    vpc_id = "${aws_vpc.rtp03-vpc.id}"
    cidr_block = "10.1.1.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "ap-south-1a"
    tags = {
      Name = "rtp01-public_subent_01"
    }
}

resource "aws_subnet" "rtp02-public_subent_02" {
    vpc_id = "${aws_vpc.rtp03-vpc.id}"
    cidr_block = "10.1.2.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "ap-south-1b"
    tags = {
      Name = "rtp02-public_subent_02"
    }
}

resource "aws_subnet" "rtp03-public_subent_03" {
    vpc_id = "${aws_vpc.rtp03-vpc.id}"
    cidr_block = "10.1.3.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "ap-south-1c"
    tags = {
      Name = "rtp03-public_subent_03"
    }
}

//Creating a Internet Gateway
resource "aws_internet_gateway" "rtp03-igw" {
    vpc_id = "${aws_vpc.rtp03-vpc.id}"
    tags = {
      Name = "rtp03-igw"
    }
}

// Create a route table
resource "aws_route_table" "rtp03-public-rt" {
    vpc_id = "${aws_vpc.rtp03-vpc.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.rtp03-igw.id}"
    }
    tags = {
      Name = "rtp03-public-rt"
    }
}


