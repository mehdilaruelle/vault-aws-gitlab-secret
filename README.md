﻿# Vault demonstration with Gitlab-CI and AWS

This repository is dedicated to the talk: **Secure your Terraform deploy in Gitlab-CI with Vault**

**Disclaimer:** The repository is here for demonstration purpose. meaning: No best pratice and a lot of review.

For the demonstration we need a [Gitlab repository using the CI](https://docs.gitlab.com/ce/ci/) and an [operational Vault](https://learn.hashicorp.com/collections/vault/day-one-consul) in a [AWS account](https://aws.amazon.com/fr/getting-started/).

First, configure your Vault server. Check the [README](./terraform/vault-admin/README.md).

Then, use Gitlab-CI to execute your Terraform for your project. Check the [README](./terraform/project/README.md) to know how to implement it.

## Contact

You see something wrong ? You want extra information or more ?

Contact me: <3exr269ch@mozmail.com>
