# Terraform Sherlock

Interrogate your Terraform resources with the help of the World's greatest
detectives: Steampipe + Sherlock. Terraform Sherlock allows you to perform
deep analysis of your Terraform resources and test them against operations &
security best practices.

![image](https://github.com/turbot/steampipe-mod-terraform-sherlock/blob/main/docs/terraform_sherlock_session.png?raw=true)

## Current Sherlock Checks

TBD

## Quick start

1) Download and install Steampipe (https://steampipe.io/downloads). Or use Brew:

```shell
brew tap turbot/tap
brew install steampipe

steampipe -v
steampipe version 0.10.0
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
git clone https://github.com/turbot/steampipe-mod-terraform-sherlock.git
cd steampipe-mod-terraform-sherlock
```

5) Run the checks:

```shell
steampipe check all
```

You can also run a specific controls by name:

```shell
steampipe check control.TBD
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
git clone https://github.com/turbot/steampipe-mod-terraform-sherlock.git
cd steampipe-mod-terraform-sherlock
```

Thanks for getting involved! We would love to have you [join our Slack community](https://steampipe.io/community/join) and hang out with other Steampipe Mod developers.

Please see the [contribution guidelines](https://github.com/turbot/steampipe/blob/main/CONTRIBUTING.md) and our [code of conduct](https://github.com/turbot/steampipe/blob/main/CODE_OF_CONDUCT.md). All contributions are subject to the [Apache 2.0 open source license](https://github.com/turbot/steampipe-mod-aws-compliance/blob/main/LICENSE).

`help wanted` issues:
- [Steampipe](https://github.com/turbot/steampipe/labels/help%20wanted)
- [Terraform Sherlock Mod](https://github.com/turbot/steampipe-mod-terraform-sherlock/labels/help%20wanted)
