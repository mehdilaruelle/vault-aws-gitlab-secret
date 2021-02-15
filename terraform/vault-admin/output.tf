output "pipeline_auth_path" {
  description = "The path of the Vault JWT auth backend for pipeline"
  value = vault_jwt_auth_backend.gitlab.path
}

output "pipeline_auth_role" {
  description = "The role name of the Vault JWT auth backend for pipeline"
  value = vault_jwt_auth_backend_role.pipeline.role_name
}

output "pipeline_path_secret" {
  description = "The path of the AWS secret engine for pipeline"
  value = vault_aws_secret_backend.aws.path
}

output "pipeline_role_secret" {
  description = "The role name of the AWS secret engine for pipeline"
  value = vault_aws_secret_backend_role.pipeline.name
}

output "project_path_secret" {
  description = "The path of the Database secret engine for project"
  value = vault_mount.db.path
}

output "project_policy_name" {
  description = "The policy project name who give acces for project secrets"
  value = vault_policy.project.name
}
