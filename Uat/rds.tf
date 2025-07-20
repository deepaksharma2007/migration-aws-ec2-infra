
resource "aws_security_group" "rds_sg" {
  vpc_id = aws_vpc.main.id

  # Allow incoming RDS connections from the public subnet
  ingress {
    from_port   = 3306  
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.mypublic.cidr_block]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rds-security-group"
  }
}

resource "aws_db_instance" "rds_instance" {
  identifier             = "my-uat-rds-db"
  allocated_storage      = 20
  storage_type           = "gp3"
  engine                 = "mysql" 
  engine_version         = var.mysql_version 
  instance_class         = var.mysql_instance_type
  username               = var.db_username
  password               = var.db_password
  parameter_group_name   =  "default.mysql8.0"
  publicly_accessible    = false
  skip_final_snapshot    = true
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  multi_az = false
  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  tags = {
    Name = "rds-private"
  }
}
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds-subnet-group1"
  subnet_ids = [aws_subnet.myprivate1.id, aws_subnet.myprivate2.id] 

  tags = {
    Name = "rds-subnet-group1"
  }
}
