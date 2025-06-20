# Data Sources
# Lookup for latest Ubuntu 22.04 LTS 64-bit AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

# EC2 Instances

## Public Instance in us-east-2a with an Elastic IP
resource "aws_instance" "public_a_instance" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public_a.id
  key_name                    = aws_key_pair.default.key_name
  associate_public_ip_address = false # Elastic IP will be attached manually
  vpc_security_group_ids      = [aws_security_group.instance_sg.id]
  user_data                   = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get install -y docker.io amazon-ssm-agent
              systemctl enable docker
              systemctl start docker
              systemctl enable amazon-ssm-agent
              systemctl start amazon-ssm-agent
              # Install CloudWatch Agent
              wget https://s3.amazonaws.com/amazoncloudwatch-agent/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb
              dpkg -i amazon-cloudwatch-agent.deb
              systemctl enable amazon-cloudwatch-agent
              systemctl start amazon-cloudwatch-agent
              EOF

  tags = {
    Name        = "tuai-${var.environment}-public-a-instance"
    Environment = var.environment
  }
}

resource "aws_instance" "private_a_instance" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.private_a.id
  key_name               = aws_key_pair.default.key_name
  vpc_security_group_ids = [aws_security_group.instance_sg.id]
  user_data              = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get install -y docker.io amazon-ssm-agent
              systemctl enable docker
              systemctl start docker
              systemctl enable amazon-ssm-agent
              systemctl start amazon-ssm-agent
              # Install CloudWatch Agent
              wget https://s3.amazonaws.com/amazoncloudwatch-agent/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb
              dpkg -i amazon-cloudwatch-agent.deb
              systemctl enable amazon-cloudwatch-agent
              systemctl start amazon-cloudwatch-agent
              EOF

  tags = {
    Name        = "tuai-${var.environment}-private-a-instance"
    Environment = var.environment
  }
}

// resource "aws_instance" "private_b_instance" {
//  ami                    = data.aws_ami.ubuntu.id
//  instance_type          = "t2.micro"
//  subnet_id              = aws_subnet.private_b.id
//  key_name               = aws_key_pair.default.key_name
//  vpc_security_group_ids = [aws_security_group.instance_sg.id]
//  user_data              = <<-EOF
//              #!/bin/bash
//              apt-get update -y
//              apt-get install -y docker.io amazon-ssm-agent
//             systemctl enable docker
//              systemctl start docker
//              systemctl enable amazon-ssm-agent
//              systemctl start amazon-ssm-agent
//              # Install CloudWatch Agent
//              wget https://s3.amazonaws.com/amazoncloudwatch-agent/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb
//              dpkg -i amazon-cloudwatch-agent.deb
//              systemctl enable amazon-cloudwatch-agent
//              systemctl start amazon-cloudwatch-agent
//              EOF
//
//  tags = {
//    Name        = "tuai-${var.environment}-public-a-instance"
//    Environment = var.environment
//  }
// }

resource "aws_eip" "public_a_eip" {
  instance = aws_instance.public_a_instance.id

}

## Public Instance in us-east-2b with an Elastic IP
// resource "aws_instance" "public_b_instance" {
//  ami                         = data.aws_ami.ubuntu.id
//  instance_type               = "t2.micro"
//  subnet_id                   = aws_subnet.public_b.id
//  key_name                    = aws_key_pair.default.key_name
//  associate_public_ip_address = false
//  vpc_security_group_ids      = [aws_security_group.instance_sg.id]
//  user_data                   = <<-EOF
//              <<-EOF
//              #!/bin/bash
//              apt-get update -y
//              apt-get install -y docker.io amazon-ssm-agent
//              systemctl enable docker
//              systemctl start docker
//              systemctl enable amazon-ssm-agent
//              systemctl start amazon-ssm-agent
//              # Install CloudWatch Agent
//              wget https://s3.amazonaws.com/amazoncloudwatch-agent/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb
//              dpkg -i amazon-cloudwatch-agent.deb
//              systemctl enable amazon-cloudwatch-agent
//              systemctl start amazon-cloudwatch-agent
//              EOF
//
//  tags = {
//    Name        = "tuai-${var.environment}-public-b-instance"
//    Environment = var.environment
//  }
// }

// resource "aws_eip" "public_b_eip" {
//  instance = aws_instance.public_b_instance.id
//}
