variable "region" {
  description = "AWS regions"
  default     = "eu-west-1"
}

variable "gitlab_domain" {
  description = "The domain name of your gitlab (e.g: gitlab.com)"
}

variable "gitlab_project_id" {
  description = "The pipeline ID to authorize to auth with Vault"
}

variable "vault_aws_assume_role" {
  description = "The AWS arn role for Vault to assume for AWS auth backend"
}

variable "application_aws_assume_role" {
  description = "The AWS arn role for Vault to assume for AWS Secret engine. The AWS credentials are pass to the application."
}

##### OPTIONS #####
variable "project_name" {
  description = "Project name (ex: web)"
  default     = "web"
}

variable "gitlab_project_branch" {
  description = "The pipeline project branch to authorize to auth with Vault"
  default     = "master"
}

variable "aws_secret_default_ttl" {
  description = "The default lease ttl for AWS secret engine (default: 10min)"
  default     = 600
}

variable "aws_secret_max_ttl" {
  description = "The max lease ttl for AWS secret engine (default: 15min)"
  default     = 900
}

variable "jwt_token_max_ttl" {
  description = "The token max ttl for JWT auth backend (default: 15min)"
  default     = 900
}

variable "jwt_auth_tune_default_ttl" {
  description = "The tune default lease ttl for JWT auth backend (default: 10min)"
  default     = "10m"
}
variable "jwt_auth_tune_max_ttl" {
  description = "The tune max lease ttl for JWT auth backend (default: 15min)"
  default     = "15m"
}
