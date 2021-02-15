# Presentation

This Terraform folder is dedicated to Gitlab-CI (your pipeline).
You should use Terraform only in Gitlab-ci for this project.

It will deploy a website using Vault to get dynamic secrets to authenticate into a database.

## Prerequisite

### Before to start

Refer to the [README](../vault-admin/README.md) to setup your Vault first.

Then check the [gitlab-ci file](../../.gitlab-ci.yml). The **gitlab-ci** file will handle your CI and also execute your Terraform.

### About your Gitlab-CI file

The **gitlab-ci.yml** will execute your CI inside Gitlab-CI and also deploy your project (using Terraform).

The [gitlab-ci file](../../.gitlab-ci.yml) have 3 stages:
- `test`: This stage have 1 job. This job is to check if your pipeline can be authenticate into your Vault through the JWT auth backend.
- `plan`: This stage have 1 job. This job is to authenticate into your Vault through the JWT auth backend and do a `terraform plan`. It will also test if you can access to the AWS secret engine and generate AWS secrets.
- `deploy`: The stage have 2 jobs. The job `apply` will use `terraform apply` based and the previous `terraform plan`. The second job `destroy` will use `terraform destroy` and will destroy your project infrastructure. Both need to be manually execute through Gitlab-CI.

You have also a `before_script` where your Gitlab-ci will install **Vault** and **Terraform** binaries.

### Environment variables

In your Gitlab project, in **Settings** and **CI/CD**, add a variable:
- `VAULT_ADDR`: The value should be the address of your Vault server.

## What this Terraform do ?

For the AWS side, it will create a RDS database with a mysql as a database engine and an EC2 instance with your website.

For the Vault side :
- The RDS secrets are stored into the `Database secret engine` in Vault.
- The EC2 have a Vault role created in the `AWS auth backend` based on the EC2 metadata (e.g: account ID, subnet ID, etc).

Your website will able to authenticate into Vault with `AWS auth backend` and then use Vault Database secrets to authenticate into the RDS database through the `Database secret engine`.

### Vault agent

> WIP

## Requirements

| Name | Version |
|------|---------|
| aws | ~>3.23 |
| vault | ~>2.14.0 |

## Providers

| Name | Version |
|------|---------|
| aws | ~>3.23 |
| random | n/a |
| template | n/a |
| vault | ~>2.14.0 |

## Modules

No Modules.

## Resources

| Name |
|------|
| [aws_ami](https://registry.terraform.io/providers/hashicorp/aws/~>3.23/docs/data-sources/ami) |
| [aws_caller_identity](https://registry.terraform.io/providers/hashicorp/aws/~>3.23/docs/data-sources/caller_identity) |
| [aws_db_instance](https://registry.terraform.io/providers/hashicorp/aws/~>3.23/docs/resources/db_instance) |
| [aws_instance](https://registry.terraform.io/providers/hashicorp/aws/~>3.23/docs/resources/instance) |
| [aws_security_group](https://registry.terraform.io/providers/hashicorp/aws/~>3.23/docs/resources/security_group) |
| [aws_vpc](https://registry.terraform.io/providers/hashicorp/aws/~>3.23/docs/data-sources/vpc) |
| [random_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) |
| [template_file](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) |
| [vault_aws_access_credentials](https://registry.terraform.io/providers/hashicorp/vault/~>2.14.0/docs/data-sources/aws_access_credentials) |
| [vault_aws_auth_backend_role](https://registry.terraform.io/providers/hashicorp/vault/~>2.14.0/docs/resources/aws_auth_backend_role) |
| [vault_database_secret_backend_connection](https://registry.terraform.io/providers/hashicorp/vault/~>2.14.0/docs/resources/database_secret_backend_connection) |
| [vault_database_secret_backend_role](https://registry.terraform.io/providers/hashicorp/vault/~>2.14.0/docs/resources/database_secret_backend_role) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aws\_db\_instance\_class | The RDS instance class (default: db.t3.micro) | `string` | `"db.t3.micro"` | no |
| aws\_instance\_type | The AWS instance EC2 type (default: t3.micro) | `string` | `"t3.micro"` | no |
| db\_admin\_username | The admin username of the database (default: admin) | `string` | `"admin"` | no |
| db\_secret\_ttl | The secret database TTL (default: 1min) | `number` | `60` | no |
| project\_name | Project name (default: web) | `string` | `"web"` | no |
| project\_token\_max\_ttl | The Vault token max ttl (default: 2min) | `number` | `120` | no |
| project\_token\_ttl | The Vault token default ttl (default: 1min) | `number` | `60` | no |
| region | AWS regions | `string` | `"eu-west-1"` | no |
| secret\_id\_num\_uses | The number uses for secret ID (default: 0) | `number` | `0` | no |
| secret\_id\_ttl | The secret ID TTL (default: 10min) | `number` | `600` | no |
| token\_max\_ttl | The token max TTL (default: 10min) | `number` | `600` | no |
| token\_num\_uses | The number uses for token (default: 0) | `number` | `0` | no |
| token\_ttl | The token TTL (default: 1min) | `number` | `60` | no |
| vault\_addr | The vault address (endpoint). | `any` | n/a | yes |
| vault\_agent\_parameters | The parameters to pass as environment variables to your Vault Agent (ex: VAULT\_NAMESPACE='test') | `string` | `""` | no |
| vault\_agent\_version | The Vault Agent version used (default: 1.6.2) | `string` | `"1.6.2"` | no |
| vault\_backend | Vault PATH backend to be authenticate. | `any` | n/a | yes |
| vault\_role | Vault role name to use to be authenticate. | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| db\_endpoint | The endpoint to the RDS database |
| db\_engine | The database engine used by your RDS database |
| db\_name | The database name created by your RDS database |
| db\_user | The admin username of your database |
| vault\_path\_db\_rotate | The Vault database secret path to rotate the root user password |
| web\_endpoint | The endpoint to your website. Copy/paste the endpoint into a web browser to test it. |
| web\_instance\_public\_ip | The AWS EC2 instnce public ipv4 |
