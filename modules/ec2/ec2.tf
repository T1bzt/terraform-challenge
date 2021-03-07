data "aws_ami" "amazon_linux" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name = "name"

    values = [
      "amzn-ami-hvm-*-x86_64-gp2",
    ]
  }

  filter {
    name = "owner-alias"

    values = [
      "amazon",
    ]
  }
}

resource "aws_iam_role" "ec2_role" {
  name = "EC2-Role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
inline_policy {
    name = "SSM_Policy"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action   = [
            "ssmmessages:*",
             "ssm:UpdateInstanceInformation",
            "ec2messages:*"
          ]
          Effect   = "Allow"
          Resource = "*"
        },
      ]
    })
  } 
}
resource "aws_iam_instance_profile" "instance_profile" {
  name = "my-ec2-instance-profile"
  role = aws_iam_role.ec2_role.name
  path = "/"
}

# Create instance
resource "aws_instance" "http" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"
  vpc_security_group_ids = var.vpc_security_group_ids
  subnet_id = var.subnet_id
  root_block_device {
    volume_type = "standard"
    volume_size = "10"
  }
  tags = {
    Name = "docker-instance"
  }
  iam_instance_profile = aws_iam_instance_profile.instance_profile.name
}

# Attach floating ip on instance http
resource "aws_eip" "public_http" {
  vpc        = true
  instance   = aws_instance.http.id
  tags = {
    Name = "public-http"
  }
}

