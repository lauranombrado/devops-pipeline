resource "aws_db_instance" "gitlab_postgres" {
  allocated_storage = 50
  storage_type = "gp2"
  engine = "postgres"
  instance_class = "db.m5.large"
  multi_az = var.gitlab_rds_multiAZ
  db_subnet_group_name = aws_db_subnet_group.default.name
  db_name = "gitlab"
  identifier = "gitlab"
  username = "gitlab"
  password = var.gitlab_postgresql_password
  vpc_security_group_ids = [aws_security_group.sg_db.id]
  skip_final_snapshot = true
}