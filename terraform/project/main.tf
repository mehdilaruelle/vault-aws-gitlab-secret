data "aws_caller_identity" "current" {}

data "aws_vpc" "default" {
  default = true
}

data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

resource "aws_security_group" "web" {
  name        = "${var.project_name}-web"
  description = "Allow HTTP inbound traffic"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "Authorize HTTP interaction with web server"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.project_name
  }
}

data "template_file" "userdata" {
  template = file("${path.module}/userdata.sh")
  vars = {
    vault_addr = var.vault_addr
    db_host = aws_db_instance.web.endpoint
    db_name = aws_db_instance.web.name
    vault_auth_path = local.aws_backend
    vault_version = var.vault_agent_version
    vault_agent_parameters = var.vault_agent_parameters
  }
}

resource "aws_instance" "web" {
  ami                    = data.aws_ami.amazon-linux-2.id
  instance_type          = var.aws_instance_type
  vpc_security_group_ids = [aws_security_group.web.id]
  user_data              = data.template_file.userdata.rendered
  monitoring             = false

  tags = {
    Name = var.project_name
  }
  volume_tags = {
    Name = var.project_name
  }
}

resource "aws_security_group" "db" {
  name        = "${var.project_name}-db"
  description = "Allow mysql inbound traffic"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "Authorize HTTP interaction with webserv"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.project_name
  }
}

resource "random_password" "password" {
  length = 16
  special = true
  override_special = "!#$%^&*()-_=+[]{}<>:?"
}

resource "aws_db_instance" "web" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "8.0.21"
  instance_class       = var.aws_db_instance_class
  name                 = var.project_name
  username             = var.db_admin_username
  password             = random_password.password.result
  parameter_group_name = "default.mysql8.0"
  vpc_security_group_ids = [aws_security_group.db.id]
  publicly_accessible = true

  tags = {
    Name = var.project_name
  }
}
