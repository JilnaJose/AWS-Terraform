resource "aws_vpc" "main" {
  cidr_block = "192.168.0.0/16"
  tags = {
    Name = "main"
  }
}

resource "aws_subnet" "public_subnet_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "192.168.40.0/24"
  availability_zone = "eu-west-1a"

  tags = {
    Name = "public subnet 1"
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "192.168.41.0/24"
  availability_zone = "eu-west-1b"

  tags = {
    Name = "public subnet 2"
  }
}

resource "aws_subnet" "public_subnet_3" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "192.168.42.0/24"
  availability_zone = "eu-west-1c"

  tags = {
    Name = "public subnet 3"
  }
}

resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "192.168.43.0/24"
  availability_zone = "eu-west-1a"


  tags = {
    Name = "private subnet 1"
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "192.168.44.0/24"
  availability_zone = "eu-west-1b"

  tags = {
    Name = "private subnet 2"
  }
}

resource "aws_subnet" "private_subnet_3" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "192.168.45.0/24"
  availability_zone = "eu-west-1c"

  tags = {
    Name = "private subnet 3"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "192.168.0.0/16"
    gateway_id = "local"
  }

  tags = {
    Name = "private"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "public"
  }
}

resource "aws_route_table_association" "public_subnet_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_subnet_2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_subnet_3" {
  subnet_id      = aws_subnet.public_subnet_3.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private_subnet_1" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_subnet_2" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_subnet_3" {
  subnet_id      = aws_subnet.private_subnet_3.id
  route_table_id = aws_route_table.private.id
}






  