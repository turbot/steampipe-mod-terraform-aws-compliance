# Terraform AWS Compliance

140+ compliance and security controls to test your Terraform AWS resources against security best practices prior to deployment in your AWS accounts.

![image](https://raw.githubusercontent.com/turbot/steampipe-mod-terraform-aws-compliance/main/docs/terraform_aws_compliance_console_output.png)

## Quick start

1) Download and install Steampipe (https://steampipe.io/downloads). Or use Brew:

```shell
brew tap turbot/tap
brew install steampipe

steampipe -v
steampipe version 0.11.2
```

2) Install the Terraform plugin:

```shell
steampipe plugin install terraform
```

3) Configure your Terraform creds: [Instructions](https://hub.steampipe.io/plugins/turbot/terraform#configuration)

`vi ~/.steampipe/config/terraform.spc`
```hcl
connection "terraform" {
  plugin = "terraform"
  paths  = ["/path/to/my/tf/files/*"]
}
```

4) Clone this repo and step into the directory:

```sh
git clone https://github.com/turbot/steampipe-mod-terraform-aws-compliance
cd steampipe-mod-terraform-aws-compliance
```

5) Run the checks:

```shell
steampipe check all
```

Run all benchmarks for a specific compliance framework using tags:

```shell
steampipe check all --tag gdpr=true
```

Run a benchmark:

```shell
steampipe check terraform_aws_compliance.benchmark.s3
```

Run a specific control:

```shell
steampipe check terraform_aws_compliance.control.s3_bucket_default_encryption_enabled
```

Use introspection to view the available controls:
```
steampipe query "select resource_name from steampipe_control;"
```

## Contributing

Have an idea for additional checks or best practices?
- **[Join our Slack community →](https://steampipe.io/community/join)**
- **[Mod developer guide →](https://steampipe.io/docs/steampipe-mods/writing-mods.md)**

**Prerequisites**:
- [Steampipe installed](https://steampipe.io/downloads)
- Steampipe Terraform plugin installed (see above)

**Fork**:
Click on the Terraform Fork Widget. (Don't forget to :star: the repo!)

**Clone**:

```sh
git clone https://github.com/turbot/steampipe-mod-terraform-aws-compliance
cd steampipe-mod-terraform-aws-compliance
```

Thanks for getting involved! We would love to have you [join our Slack community](https://steampipe.io/community/join) and hang out with other Steampipe Mod developers.

Please see the [contribution guidelines](https://github.com/turbot/steampipe/blob/main/CONTRIBUTING.md) and our [code of conduct](https://github.com/turbot/steampipe/blob/main/CODE_OF_CONDUCT.md). All contributions are subject to the [Apache 2.0 open source license](https://github.com/turbot/steampipe-mod-aws-compliance/blob/main/LICENSE).

`help wanted` issues:
- [Steampipe](https://github.com/turbot/steampipe/labels/help%20wanted)
- [Terraform AWS Compliance Mod](https://github.com/turbot/steampipe-mod-terraform-aws-compliance/labels/help%20wanted)
