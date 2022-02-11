# Terraform AWS Compliance

140+ compliance and security controls to test your Terraform AWS resources against security best practices prior to deployment in your AWS accounts.

![image](https://raw.githubusercontent.com/turbot/steampipe-mod-terraform-aws-compliance/main/docs/terraform_aws_compliance_console_output.png)

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

If running from the current working directory containing your Terraform
configuration files, the Steampipe workspace must be set to the location where
you downloaded the `steampipe-mod-terraform-aws-compliance` mod:

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

## Contributing

If you have an idea for additional compliance controls, or just want to help maintain and extend this mod ([or others](https://github.com/topics/steampipe-mod)) we would love for you to join the community and start contributing!

Have an idea for additional checks or best practices?
- **[Join our Slack community →](https://steampipe.io/community/join)** and hang out with other Mod developers
- **[Mod developer guide →](https://steampipe.io/docs/using-steampipe/writing-controls)**

Please see the [contribution guidelines](https://github.com/turbot/steampipe/blob/main/CONTRIBUTING.md) and our [code of conduct](https://github.com/turbot/steampipe/blob/main/CODE_OF_CONDUCT.md). All contributions are subject to the [Apache 2.0 open source license](https://github.com/turbot/steampipe-mod-terraform-aws-compliance/blob/main/LICENSE).

`help wanted` issues:
- [Steampipe](https://github.com/turbot/steampipe/labels/help%20wanted)
- [Terraform AWS Compliance Mod](https://github.com/turbot/steampipe-mod-terraform-aws-compliance/labels/help%20wanted)
