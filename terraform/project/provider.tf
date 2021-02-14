provider "vault" {
  address = var.vault_addr
}

data "vault_aws_access_credentials" "creds" {
  backend = var.vault_backend
  role    = var.vault_role
  type    = "sts"
}

provider "aws" {
  region     = var.region
  access_key = data.vault_aws_access_credentials.creds.access_key
  secret_key = data.vault_aws_access_credentials.creds.secret_key
  token = data.vault_aws_access_credentials.creds.security_token
}
