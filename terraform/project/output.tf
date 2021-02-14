output "web_instance_public_ip" {
  value = aws_instance.web.public_ip
}

output "web_endpoint" {
  value = "http://${aws_instance.web.public_ip}"
}

output "db_endpoint" {
  value = aws_db_instance.web.endpoint
}

output "db_engine" {
  value = aws_db_instance.web.engine
}

output "db_name" {
  value = aws_db_instance.web.name
}

output "db_user" {
  value = aws_db_instance.web.username
}

output "vault_path_db" {
  value = "web-db/rotate-root/mysql"
}
