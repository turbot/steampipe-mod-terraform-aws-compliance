---
repository: "https://github.com/turbot/steampipe-mod-terraform-aws-compliance"
---

# Terraform AWS Compliance

Run compliance and security controls to detect Terraform AWS resources deviating from security best practices prior to deployment in your AWS accounts.

<img src="https://raw.githubusercontent.com/turbot/steampipe-mod-terraform-aws-compliance/main/docs/terraform_aws_compliance_dashboard.png" width="50%" type="thumbnail"/>
<img src="https://raw.githubusercontent.com/turbot/steampipe-mod-terraform-aws-compliance/main/docs/terraform_aws_compliance_ec2_dashboard.png" width="50%" type="thumbnail"/>
<img src="https://raw.githubusercontent.com/turbot/steampipe-mod-terraform-aws-compliance/main/docs/terraform_aws_compliance_console_output.png" width="50%" type="thumbnail"/>

## References

[Terraform](https://terraform.io/) is an open-source infrastructure as code software tool that provides a consistent CLI workflow to manage hundreds of cloud services.

[Steampipe](https://steampipe.io) is an open source CLI to instantly query cloud APIs using SQL.

[Steampipe Mods](https://steampipe.io/docs/reference/mod-resources#mod) are collections of `named queries`, and codified `controls` that can be used to test current configuration of your cloud resources against a desired configuration.

## Documentation

- **[Benchmarks and controls →](https://hub.steampipe.io/mods/turbot/terraform_aws_compliance/controls)**
- **[Named queries →](https://hub.steampipe.io/mods/turbot/terraform_aws_compliance/queries)**

## Getting started

### Installation

Download and install Steampipe (https://steampipe.io/downloads). Or use Brew:

```sh
brew tap turbot/tap
brew install steampipe
```

Install the terraform plugin with [Steampipe](https://steampipe.io):

```sh
steampipe plugin install terraform
```

Clone:

```sh
git clone https://github.com/turbot/steampipe-mod-terraform-aws-compliance.git
cd steampipe-mod-terraform-aws-compliance
```

### Configuration

By default, the Terraform plugin configuration loads Terraform configuration
files in your current working directory. If you are running benchmarks and
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

If you are running from the current working directory containing your Terraform
configuration files, the Steampipe workspace must be set to the location where
you downloaded the `steampipe-mod-terraform-aws-compliance` mod:

Set through an environment variable:

```sh
export STEAMPIPE_WORKSPACE_CHDIR=/path/to/steampipe-mod-terraform-aws-compliance
```

Set through the CLI argument:

```sh
steampipe check all --workspace-chdir=/path/to/steampipe-mod-terraform-aws-compliance
```

However, if you are running from within the
`steampipe-mod-terraform-aws-compliance` mod directory and `paths` was
configured in the Terraform plugin configuration, the Steampipe workspace does
not need to be set (since you are already in the Steampipe workspace
directory).

Start your dashboard server to get started:

```sh
steampipe dashboard
```

By default, the dashboard interface will then be launched in a new browser
window at https://localhost:9194. From here, you can run benchmarks by
selecting one or searching for a specific one.

Instead of running benchmarks in a dashboard, you can also run them within your
terminal with the `steampipe check` command.

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
terraform_aws_compliance.control.s3_bucket_default_encryption_enabled
```

Different output formats are also available, for more information please see
[Output Formats](https://steampipe.io/docs/reference/cli/check#output-formats).

## Contributing

If you have an idea for additional controls or just want to help maintain and extend this mod ([or others](https://github.com/topics/steampipe-mod)) we would love you to join the community and start contributing.

- **[Join our Slack community →](https://steampipe.io/community/join)** and hang out with other Mod developers.

Please see the [contribution guidelines](https://github.com/turbot/steampipe/blob/main/CONTRIBUTING.md) and our [code of conduct](https://github.com/turbot/steampipe/blob/main/CODE_OF_CONDUCT.md). All contributions are subject to the [Apache 2.0 open source license](https://github.com/turbot/steampipe-mod-terraform-aws-compliance/blob/main/LICENSE).

Want to help but not sure where to start? Pick up one of the `help wanted` issues:

- [Steampipe](https://github.com/turbot/steampipe/labels/help%20wanted)
- [Terraform AWS Compliance Mod](https://github.com/turbot/steampipe-mod-terraform-aws-compliance/labels/help%20wanted)
