resource "random_password" "db_master_pass" {
  length            = 40
  special           = true
  min_special       = 5
  override_special  = "!#$%^&*()-_=+[]{}<>:?"
  keepers           = {
    pass_version  = 1
  }
}
resource "aws_db_subnet_group" "db-subnet-group" {
  name       = "tf-challenge-subnet-group"
  subnet_ids = [var.private_subnet_id]
}

resource "aws_db_instance" "mysql_db" {
  identifier = "demodb"

  engine            = "mysql"
  engine_version    = "5.7.19"
  instance_class    = "db.t2.micro"
  allocated_storage = 5

  name     = "demodb"
  username = "user"
  port     = "3306"
  password = random_password.db_master_pass.result
  vpc_security_group_ids = [aws_security_group.db-sg.id]
  db_subnet_group_name = aws_db_subnet_group.db-subnet-group.id
  multi_az= "false"
}

resource "aws_secretsmanager_secret" "db-pass" {
  name = "db-pass-tf-challenge"
}

resource "aws_secretsmanager_secret_version" "db-pass-val" {
  secret_id     = aws_secretsmanager_secret.db-pass.id
  secret_string = random_password.db_master_pass.result
}

resource "aws_security_group" "db-sg" {
  name = "rds-sg"

  description = "RDS (terraform-managed)"
  vpc_id      = var.vpc_id

  # Only MySQL in
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}