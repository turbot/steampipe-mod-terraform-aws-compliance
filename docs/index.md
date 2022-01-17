---
repository: "https://github.com/turbot/steampipe-mod-terraform-aws-compliance"
---

# Terraform AWS Compliance

Lightweight, security and compliance-focused framework for Terraform. Run individual configuration, compliance and security controls for individual AWS services across all your AWS accounts using Steampipe.

<!-- ![image](https://raw.githubusercontent.com/turbot/steampipe-mod-aws-compliance/main/docs/aws_cis_v140_console.png) -->

## References

[Terraform](https://terraform.io/) is an open-source infrastructure as code software tool that provides a consistent CLI workflow to manage hundreds of cloud services.

[Steampipe](https://steampipe.io) is an open source CLI to instantly query cloud APIs using SQL.

[Steampipe Mods](https://steampipe.io/docs/reference/mod-resources#mod) are collections of `named queries`, and codified `controls` that can be used to test current configuration of your cloud resources against a desired configuration.


## Documentation

- **[Benchmarks and controls →](https://hub.steampipe.io/mods/turbot/terraform_aws_compliance/controls)**
- **[Named queries →](https://hub.steampipe.io/mods/turbot/terraform_aws_compliance/queries)**

## Get started

Install the Terraform plugin with [Steampipe](https://steampipe.io):

```shell
steampipe plugin install terraform
```

Clone:

```sh
git clone https://github.com/turbot/steampipe-mod-terraform-aws-compliance.git
cd steampipe-mod-terraform-aws-compliance
```

Run all benchmarks:

```shell
steampipe check all
```

Run a benchmark:

```shell
steampipe check terraform_aws_compliance.benchmark.s3
```

Run a specific control:

```shell
steampipe check terraform_aws_compliance.control.s3_bucket_default_encryption_enabled
```

### Credentials

This mod uses the credentials configured in the [Steampipe Terraform plugin](https://hub.steampipe.io/plugins/turbot/).

### Configuration

No extra configuration is required.

## Get involved

* Contribute: [Terraform Repo](https://github.com/turbot/steampipe-mod-terraform-aws-compliance)
* Community: [Slack Channel](https://steampipe.io/community/join)
