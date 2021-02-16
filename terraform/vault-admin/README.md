# Presentation

This Terraform folder is dedicated to configure the Vault server.
You should have admin right to configure it.

> This folder will only use the Vault provider and do not create AWS resources

## Prerequisite

### Before to start

You should prepare your Vault and AWS environment.
At this stage, we considere you use a Vault who is already operational.

#### On the Vault side

You should have configure:
- 1 Vault user who is already created and authenticate into Vault server
- The Vault user should have admin right

#### On the AWS side

You should have configure:
- The Vault server should have a IAM role (instance profile if EC2 is used)
- A Vault IAM role to the target AWS account where the project will be deployed. This role should be assumable by Vault server and give enough right to Vault to check identity (e.g: EC2) for the AWS auth backend
- A pipeline IAM role to the target AWS account where the projet will be deployed. This role should be assumable by Vault server and give right for your pipeline (e.g: EC2:* or RDS:*). This role will be use by the AWS Secret engine.

##### Vault IAM role (instance profile)

> A rework will be done

```
{
    "Version": "2012-10-17",
    "Statement": {
        "Effect": "Allow",
        "Action": "sts:AssumeRole",
        "Resource": "*"
    }
}
```

##### Vault assumable role for AWS auth backend

> A rework will be done

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeInstances",
                "iam:GetInstanceProfile",
                "iam:GetUser",
                "iam:GetRole"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "iam:AttachUserPolicy",
                "iam:CreateAccessKey",
                "iam:DeleteAccessKey",
                "iam:DeleteUserPolicy",
                "iam:DetachUserPolicy",
                "iam:ListAccessKeys",
                "iam:ListAttachedUserPolicies",
                "iam:ListGroupsForUser",
                "iam:ListUserPolicies",
                "iam:PutUserPolicy",
            ],
            "Resource": [
                "arn:aws:iam::ACCOUNT_ID_PROJECT:user/vault-*"
            ]
        }
    ]
}
```

Modify the trust policy with the Vault source AWS account ID as a trust.

##### Vault assumable role for pipeline (AWS secret engine)

This will use only AWS IAM managed policy (you can use least privilege with your own policy if need):
- `AmazonRDSFullAccess`
- `AmazonEC2FullAccess`
- `IAMReadOnlyAccess`

Modify the trust policy with the Vault source AWS account ID as a trust.

### Environment variables

What you need to setup:
- `VAULT_ADDR` environment variable with the Vault address
- `VAULT_NAMESPACE` environment variable if you use namespace
- `VAULT_TOKEN` environment variable with temporary Vault user
admin variable.


### Provide terraform.tfvars file

You should provide some required value for your Terraform. Keep it mind, the `.gitignore`
will not push your `terraform.tfvars` file if you use it to setup your variables.

Refer to the section `Input` below to check which variables to setup.

## What this Terraform do ?

It will create JWT auth backend and AWS secret engine for pipeline, AWS auth backend and policy for project.

## Requirements

| Name | Version |
|------|---------|
| vault | ~>2.17.0 |

## Providers

| Name | Version |
|------|---------|
| vault | ~>2.17.0 |

## Modules

No Modules.

## Resources

| Name |
|------|
| [vault_auth_backend](https://registry.terraform.io/providers/hashicorp/vault/~>2.17.0/docs/resources/auth_backend) |
| [vault_aws_auth_backend_sts_role](https://registry.terraform.io/providers/hashicorp/vault/~>2.17.0/docs/resources/aws_auth_backend_sts_role) |
| [vault_aws_secret_backend](https://registry.terraform.io/providers/hashicorp/vault/~>2.17.0/docs/resources/aws_secret_backend) |
| [vault_aws_secret_backend_role](https://registry.terraform.io/providers/hashicorp/vault/~>2.17.0/docs/resources/aws_secret_backend_role) |
| [vault_jwt_auth_backend](https://registry.terraform.io/providers/hashicorp/vault/~>2.17.0/docs/resources/jwt_auth_backend) |
| [vault_jwt_auth_backend_role](https://registry.terraform.io/providers/hashicorp/vault/~>2.17.0/docs/resources/jwt_auth_backend_role) |
| [vault_mount](https://registry.terraform.io/providers/hashicorp/vault/~>2.17.0/docs/resources/mount) |
| [vault_policy](https://registry.terraform.io/providers/hashicorp/vault/~>2.17.0/docs/resources/policy) |
| [vault_policy_document](https://registry.terraform.io/providers/hashicorp/vault/~>2.17.0/docs/data-sources/policy_document) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| application\_aws\_assume\_role | The AWS arn role for Vault to assume for AWS Secret engine. The AWS credentials are pass to the application. | `any` | n/a | yes |
| aws\_secret\_default\_ttl | The default lease ttl for AWS secret engine (default: 10min) | `number` | `600` | no |
| aws\_secret\_max\_ttl | The max lease ttl for AWS secret engine (default: 15min) | `number` | `900` | no |
| gitlab\_domain | The domain name of your gitlab (e.g: gitlab.com) | `any` | n/a | yes |
| gitlab\_project\_branch | The pipeline project branch to authorize to auth with Vault | `string` | `"master"` | no |
| gitlab\_project\_id | The pipeline ID to authorize to auth with Vault | `any` | n/a | yes |
| jwt\_auth\_tune\_default\_ttl | The tune default lease ttl for JWT auth backend (default: 10min) | `string` | `"10m"` | no |
| jwt\_auth\_tune\_max\_ttl | The tune max lease ttl for JWT auth backend (default: 15min) | `string` | `"15m"` | no |
| jwt\_token\_max\_ttl | The token max ttl for JWT auth backend (default: 15min) | `number` | `900` | no |
| project\_name | Project name (ex: web) | `string` | `"web"` | no |
| region | AWS regions | `string` | `"eu-west-1"` | no |
| vault\_aws\_assume\_role | The AWS arn role for Vault to assume for AWS auth backend | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| pipeline\_auth\_path | The path of the Vault JWT auth backend for pipeline |
| pipeline\_auth\_role | The role name of the Vault JWT auth backend for pipeline |
| pipeline\_path\_secret | The path of the AWS secret engine for pipeline |
| pipeline\_role\_secret | The role name of the AWS secret engine for pipeline |
| project\_path\_secret | The path of the Database secret engine for project |
| project\_policy\_name | The policy project name who give acces for project secrets |
