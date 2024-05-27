
# Define the RDS instance resource
resource "aws_db_instance" "postgres_instance" {
  identifier	      = "rds-test"
  allocated_storage    = 20 # Storage in GB
  engine              = "postgres"
  engine_version      = "14.7" # Choose a compatible Postgres version
  instance_class   = "db.t3.micro" # Instance class
  backup_retention_period = 1 # Number of days to retain backups
  port               = 5432
  publicly_accessible = false # Set to true if your application needs public access

  # Username and password for the database user
  username             = var.username
  password             = var.password

skip_final_snapshot = true
  # VPC configuration
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
}



# Security group to allow access to the database (optional)
resource "aws_security_group" "rds_sg" {
  name = "rds-security-group"
  description = "Security group for RDS instance"

  ingress {
    from_port = 5432
    to_port = 5432
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Replace with your allowed IP address range
  }
}

# Output the endpoint for connecting to the database
output "endpoint" {
  value = aws_db_instance.postgres_instance.endpoint
}

# Outputs for RDS credentials and endpoint
output "rds_username" {
  value = aws_db_instance.postgres_instance.username
#  sensitive = true
}

output "rds_password" {
  value = aws_db_instance.postgres_instance.password
 sensitive = true
}

#output "rds_endpoint" {
#  value = aws_db_instance.postgres_instance.endpoint
#}
