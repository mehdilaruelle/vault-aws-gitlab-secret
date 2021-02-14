output "pipeline_auth_path" {
  value = vault_jwt_auth_backend.gitlab.path
}

output "pipeline_auth_role" {
  value = vault_jwt_auth_backend_role.pipeline.role_name
}

output "pipeline_path_secret" {
  value = vault_aws_secret_backend.aws.path
}

output "pipeline_role_secret" {
  value = vault_aws_secret_backend_role.pipeline.name
}

output "project_path_secret" {
  value = vault_mount.db.path
}

output "project_policy_name" {
  value = vault_policy.project.name
}
