# MANDATORY
variable "vault_backend" {
  description = "Vault PATH backend to be authenticate."
}

variable "vault_role" {
  description = "Vault role name to use to be authenticate."
}

variable "vault_addr" {
  description = "The vault address (endpoint)."
}

##### OPTIONS #####
variable "region" {
  description = "AWS regions"
  default     = "eu-west-1"
}

variable "aws_instance_type" {
  description = "The AWS instance EC2 type (default: t3.micro)"
  default = "t3.micro"
}

variable "aws_db_instance_class" {
  description = "The RDS instance class (default: db.t3.micro)"
  default = "db.t3.micro"
}

variable "project_name" {
  description = "Project name (default: web)"
  default     = "web"
}

variable "project_token_ttl" {
  description = "The Vault token default ttl (default: 1min)"
  default     = 60
}

variable "project_token_max_ttl" {
  description = "The Vault token max ttl (default: 2min)"
  default     = 120
}

variable "db_admin_username" {
  description = "The admin username of the database (default: admin)"
  default     = "admin"
}

variable "secret_id_num_uses" {
  description = "The number uses for secret ID (default: 0)"
  default = 0
}

variable "secret_id_ttl" {
  description = "The secret ID TTL (default: 10min)"
  default     = 600
}

variable "token_num_uses" {
  description = "The number uses for token (default: 0)"
  default = 0
}

variable "token_ttl" {
  description = "The token TTL (default: 1min)"
  default     = 60
}

variable "token_max_ttl" {
  description = "The token max TTL (default: 10min)"
  default     = 600
}

variable "db_secret_ttl" {
  description = "The secret database TTL (default: 1min)"
  default     = 60
}

variable "vault_agent_version" {
  description = "The Vault Agent version used (default: 1.6.2)"
  default = "1.6.2"
}

variable "vault_agent_parameters" {
  description = "The parameters to pass as environment variables to your Vault Agent (ex: VAULT_NAMESPACE='test')"
  default = ""
}
