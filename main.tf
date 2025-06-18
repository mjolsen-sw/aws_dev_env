resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "dev"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-west-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "dev-public"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "dev-gw"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "dev-public-rt"
  }
}

resource "aws_route_table_association" "public_rta" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_security_group" "dev_sg" {
  name        = "dev-sg"
  vpc_id      = aws_vpc.main.id
  description = "dev security group"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.sg_ip_address]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "dev_key" {
  key_name   = "dev-key"
  public_key = file(var.public_key_path)

  tags = {
    Name = "dev-key"
  }
}

resource "aws_instance" "dev_instance" {
  ami             = data.aws_ami.latest_ubuntu.id
  instance_type   = "t3.micro"
  subnet_id       = aws_subnet.public_subnet.id
  key_name        = aws_key_pair.dev_key.key_name
  security_groups = [aws_security_group.dev_sg.name]

  tags = {
    Name = "dev-instance"
  }
}