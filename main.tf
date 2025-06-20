provider "aws" {
  region = var.aws_region
}


resource "aws_key_pair" "default" {
  key_name   = "tuai-${var.environment}-key"
  public_key = file(var.ssh_public_key_path)
}


# Security Group
resource "aws_security_group" "instance_sg" {
  name        = "tuai-${var.environment}-sg"
  description = "Allow ICMP, SSH, HTTP, and HTTPS"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "Allow all ICMP traffic"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "tuai-${var.environment}-sg"
    Environment = var.environment
  }
}




