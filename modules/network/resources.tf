###########################
#   VPC
###########################
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

data "aws_availability_zones" "available_az" {}

###########################
#   SUBNET (PUBLIC)
###########################
resource "aws_subnet" "public-0" {
  vpc_id            = "${aws_vpc.main.id}"
  availability_zone = "${element(data.aws_availability_zones.available_az.names, 0)}"
  cidr_block        = "10.0.10.0/24"

  map_public_ip_on_launch = true

  tags = {
    Name        = "Public-0"
    Group       = "Public"
    Environment = "${var.environment_name}"
  }
}
resource "aws_subnet" "public-1" {
  vpc_id            = "${aws_vpc.main.id}"
  availability_zone = "${element(data.aws_availability_zones.available_az.names, 1)}"
  cidr_block        = "10.0.11.0/24"

  map_public_ip_on_launch = true

  tags = {
    Name        = "Public-1"
    Group       = "Public"
    Environment = "${var.environment_name}"
  }
}
resource "aws_subnet" "public-2" {
  vpc_id            = "${aws_vpc.main.id}"
  availability_zone = "${element(data.aws_availability_zones.available_az.names, 2)}"
  cidr_block        = "10.0.12.0/24"

  map_public_ip_on_launch = true

  tags = {
    Name        = "Public-2"
    Group       = "Public"
    Environment = "${var.environment_name}"
  }
}

data "aws_subnet_ids" "public" {
  vpc_id = "${aws_vpc.main.id}"
  filter {
    name   = "tag:Group"
    values = ["Public"]
  }
}

###########################
#   SUBNET (APPLICATION)
###########################
resource "aws_subnet" "app-0" {
  vpc_id            = "${aws_vpc.main.id}"
  availability_zone = "${element(data.aws_availability_zones.available_az.names, 0)}"
  cidr_block        = "10.0.20.0/24"

  tags = {
    Name        = "Application-0"
    Group       = "App"
    Environment = "${var.environment_name}"
  }
}
resource "aws_subnet" "app-1" {
  vpc_id            = "${aws_vpc.main.id}"
  availability_zone = "${element(data.aws_availability_zones.available_az.names, 1)}"
  cidr_block        = "10.0.21.0/24"

  tags = {
    Name        = "Application-1"
    Group       = "App"
    Environment = "${var.environment_name}"
  }
}
resource "aws_subnet" "app-2" {
  vpc_id            = "${aws_vpc.main.id}"
  availability_zone = "${element(data.aws_availability_zones.available_az.names, 2)}"
  cidr_block        = "10.0.22.0/24"

  tags = {
    Name        = "Application-2"
    Group       = "App"
    Environment = "${var.environment_name}"
  }
}

data "aws_subnet_ids" "app" {
  vpc_id = "${aws_vpc.main.id}"
  filter {
    name   = "tag:Group"
    values = ["App"]
  }
}

###########################
#   SUBNET (DATA)
###########################
resource "aws_subnet" "data-0" {
  vpc_id            = "${aws_vpc.main.id}"
  availability_zone = "${element(data.aws_availability_zones.available_az.names, 0)}"
  cidr_block        = "10.0.30.0/24"

  tags = {
    Name        = "Data-0"
    Group       = "Data"
    Environment = "${var.environment_name}"
  }
}
resource "aws_subnet" "data-1" {
  vpc_id            = "${aws_vpc.main.id}"
  availability_zone = "${element(data.aws_availability_zones.available_az.names, 1)}"
  cidr_block        = "10.0.31.0/24"

  tags = {
    Name        = "Data-1"
    Group       = "Data"
    Environment = "${var.environment_name}"
  }
}
resource "aws_subnet" "data-2" {
  vpc_id            = "${aws_vpc.main.id}"
  availability_zone = "${element(data.aws_availability_zones.available_az.names, 2)}"
  cidr_block        = "10.0.32.0/24"

  tags = {
    Name        = "Data-2"
    Group       = "Data"
    Environment = "${var.environment_name}"
  }
}

data "aws_subnet_ids" "data" {
  vpc_id = "${aws_vpc.main.id}"
  filter {
    name   = "tag:Group"
    values = ["Data"]
  }
}

###########################
#   INTERNET GATEWAY
###########################
resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.main.id}"

  tags = {
    Name        = "IGW"
    Environment = "${var.environment_name}"
  }
}

resource "aws_route_table" "publicroute" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = "${aws_internet_gateway.igw.id}"
  }

  tags = {
    Name        = "PublicRoute"
    Environment = "${var.environment_name}"
  }
}

resource "aws_route_table_association" "route-pub-0" {
  subnet_id      = "${aws_subnet.public-0.id}"
  route_table_id = "${aws_route_table.publicroute.id}"
}
resource "aws_route_table_association" "route-pub-1" {
  subnet_id      = "${aws_subnet.public-1.id}"
  route_table_id = "${aws_route_table.publicroute.id}"
}
resource "aws_route_table_association" "route-pub-2" {
  subnet_id      = "${aws_subnet.public-2.id}"
  route_table_id = "${aws_route_table.publicroute.id}"
}

###########################
#   NAT GATEWAY
###########################
resource "aws_nat_gateway" "natgw-0" {
  allocation_id = "${aws_eip.nat-0.id}"
  subnet_id     = "${aws_subnet.public-0.id}"

  tags = {
    Name = "NAT Gateway - Subnet 0"
    Environment = "${var.environment_name}"
  }
}
resource "aws_nat_gateway" "natgw-1" {
  allocation_id = "${aws_eip.nat-1.id}"
  subnet_id     = "${aws_subnet.public-1.id}"

  tags = {
    Name = "NAT Gateway - Subnet 1"
    Environment = "${var.environment_name}"
  }
}
resource "aws_nat_gateway" "natgw-2" {
  allocation_id = "${aws_eip.nat-2.id}"
  subnet_id     = "${aws_subnet.public-2.id}"

  tags = {
    Name = "NAT Gateway - Subnet 2"
    Environment = "${var.environment_name}"
  }
}

resource "aws_eip" "nat-0" {
  vpc = true

  depends_on = ["aws_internet_gateway.igw"]
}
resource "aws_eip" "nat-1" {
  vpc = true

  depends_on = ["aws_internet_gateway.igw"]
}
resource "aws_eip" "nat-2" {
  vpc = true

  depends_on = ["aws_internet_gateway.igw"]
}

resource "aws_route_table" "natroute-0" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_nat_gateway.natgw-0.id}"
  }

  # route {
  #   ipv6_cidr_block = "::/0"
  #   gateway_id      = "${aws_nat_gateway.natgw-0.id}"
  # }

  tags = {
    Name        = "NatRoute-0"
    Environment = "${var.environment_name}"
  }
}

resource "aws_route_table_association" "route-nat-0-app" {
  subnet_id      = "${aws_subnet.app-0.id}"
  route_table_id = "${aws_route_table.natroute-0.id}"
}
resource "aws_route_table_association" "route-nat-0-data" {
  subnet_id      = "${aws_subnet.data-0.id}"
  route_table_id = "${aws_route_table.natroute-0.id}"
}

resource "aws_route_table" "natroute-1" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_nat_gateway.natgw-1.id}"
  }

  # route {
  #   ipv6_cidr_block = "::/0"
  #   gateway_id      = "${aws_nat_gateway.natgw-1.id}"
  # }

  tags = {
    Name        = "NatRoute-1"
    Environment = "${var.environment_name}"
  }
}

resource "aws_route_table_association" "route-nat-1-app" {
  subnet_id      = "${aws_subnet.app-1.id}"
  route_table_id = "${aws_route_table.natroute-1.id}"
}
resource "aws_route_table_association" "route-nat-1-data" {
  subnet_id      = "${aws_subnet.data-1.id}"
  route_table_id = "${aws_route_table.natroute-1.id}"
}

resource "aws_route_table" "natroute-2" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_nat_gateway.natgw-2.id}"
  }

  # route {
  #   ipv6_cidr_block = "::/0"
  #   gateway_id      = "${aws_nat_gateway.natgw-2.id}"
  # }

  tags = {
    Name        = "NatRoute-2"
    Environment = "${var.environment_name}"
  }
}

resource "aws_route_table_association" "route-nat-2-app" {
  subnet_id      = "${aws_subnet.app-2.id}"
  route_table_id = "${aws_route_table.natroute-2.id}"
}
resource "aws_route_table_association" "route-nat-2-data" {
  subnet_id      = "${aws_subnet.data-2.id}"
  route_table_id = "${aws_route_table.natroute-2.id}"
}