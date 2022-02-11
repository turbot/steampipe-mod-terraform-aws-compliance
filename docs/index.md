---
repository: "https://github.com/turbot/steampipe-mod-terraform-aws-compliance"
---

# Terraform AWS Compliance

Run compliance and security controls to detect Terraform AWS resources deviating from security best practices prior to deployment in your AWS accounts.

![image](https://raw.githubusercontent.com/turbot/steampipe-mod-terraform-aws-compliance/main/docs/terraform_aws_compliance_console_output.png)

## References

[Terraform](https://terraform.io/) is an open-source infrastructure as code software tool that provides a consistent CLI workflow to manage hundreds of cloud services.

[Steampipe](https://steampipe.io) is an open source CLI to instantly query cloud APIs using SQL.

[Steampipe Mods](https://steampipe.io/docs/reference/mod-resources#mod) are collections of `named queries`, and codified `controls` that can be used to test current configuration of your cloud resources against a desired configuration.

## Documentation

- **[Benchmarks and controls →](https://hub.steampipe.io/mods/turbot/terraform_aws_compliance/controls)**
- **[Named queries →](https://hub.steampipe.io/mods/turbot/terraform_aws_compliance/queries)**

## Get started

### Installation

Clone:

```sh
git clone https://github.com/turbot/steampipe-mod-terraform-aws-compliance.git
```

Install the Terraform plugin with [Steampipe](https://steampipe.io):

```sh
steampipe plugin install terraform
```

### Configuration

By default, the Terraform plugin configuration loads Terraform configuration
files in your current working directory. So if you are running benchmarks and
controls from the current working directory, no extra plugin configuration is
necessary.

If you want to run benchmarks and controls across multiple directories, they
can be run from within the `steampipe-mod-terraform-aws-compliance` mod
directory after configuring the Terraform plugin configuration:

```sh
vi ~/.steampipe/config/terraform.spc
```

```hcl
connection "terraform" {
  plugin = "terraform"
  paths  = ["/path/to/files/*.tf", "/path/to/more/files/*.tf"]
}
```

For more details on connection configuration, please refer to [Terraform Plugin Configuration](https://hub.steampipe.io/plugins/turbot/terraform#configuration).

### Usage

If running from the current working directory, the Steampipe workspace must be
set to the location where you downloaded the
`steampipe-mod-terraform-aws-compliance` mod:

Set through an environment variable:

```sh
export STEAMPIPE_WORKSPACE_CHDIR=/path/to/steampipe-mod-terraform-aws-compliance
steampipe check all
```

Set through the command line argument:

```sh
steampipe check all --workspace-chdir=/path/to/steampipe-mod-terraform-aws-compliance
```

If running from within the `steampipe-mod-terraform-aws-compliance` mod
directory and `paths` was configured in the Terraform plugin configuration, the
Steampipe workspace does not need to be set:

Run all benchmarks:

```sh
steampipe check all
```

Run all benchmarks for a specific compliance framework using tags:

```sh
steampipe check all --tag gdpr=true
```

Run a benchmark:

```sh
steampipe check terraform_aws_compliance.benchmark.s3
```

Run a specific control:

```sh
steampipe check terraform_aws_compliance.control.s3_bucket_default_encryption_enabled
```

### Credentials

This mod uses the credentials configured in the [Steampipe Terraform plugin](https://hub.steampipe.io/plugins/turbot/terraform).

## Get involved

* Contribute: [GitHub Repo](https://github.com/turbot/steampipe-mod-terraform-aws-compliance)
* Community: [Slack Channel](https://steampipe.io/community/join)
