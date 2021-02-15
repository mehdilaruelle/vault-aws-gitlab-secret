output "web_instance_public_ip" {
  description = "The AWS EC2 instnce public ipv4"
  value = aws_instance.web.public_ip
}

output "web_endpoint" {
  description = "The endpoint to your website. Copy/paste the endpoint into a web browser to test it."
  value = "http://${aws_instance.web.public_ip}"
}

output "db_endpoint" {
  description = "The endpoint to the RDS database"
  value = aws_db_instance.web.endpoint
}

output "db_engine" {
  description = "The database engine used by your RDS database"
  value = aws_db_instance.web.engine
}

output "db_name" {
  description = "The database name created by your RDS database"
  value = aws_db_instance.web.name
}

output "db_user" {
  description = "The admin username of your database"
  value = aws_db_instance.web.username
}

output "vault_path_db_rotate" {
  description = "The Vault database secret path to rotate the root user password"
  value = "${local.db_backend}/rotate-root/mysql"
}
