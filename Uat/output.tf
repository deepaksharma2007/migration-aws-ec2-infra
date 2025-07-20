
output "public_instance_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.public_instance.public_ip
}

output "rds_endpoint" {
  description = "Endpoint of the RDS instance"
  value       = aws_db_instance.rds_instance.endpoint
}
