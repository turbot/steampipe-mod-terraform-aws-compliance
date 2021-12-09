---
repository: "https://.com/turbot/steampipe-mod-terraform-sherlock"
---

# Terraform Sherlock Mod

Interrogate your Terraform resources with the help of the world's greatest detectives: Steampipe + Sherlock.

## References

[Terraform](https://terraform.io/) is an open-source infrastructure as code software tool that provides a consistent CLI workflow to manage hundreds of cloud services.

[Steampipe](https://steampipe.io) is an open source CLI to instantly query cloud APIs using SQL.

[Steampipe Mods](https://steampipe.io/docs/reference/mod-resources#mod) are collections of `named queries`, and codified `controls` that can be used to test current configuration of your cloud resources against a desired configuration.


## Documentation

- **[Benchmarks and controls →](https://hub.steampipe.io/mods/turbot/_sherlock/controls)**
- **[Named queries →](https://hub.steampipe.io/mods/turbot/_sherlock/queries)**

## Get started

Install the Terraform plugin with [Steampipe](https://steampipe.io):

```shell
steampipe plugin install terraform
```

Clone:

```sh
git clone https://github.com/turbot/steampipe-mod-terraform-sherlock.git
cd steampipe-mod-terraform-sherlock
```

Run all benchmarks:

```shell
steampipe check all
```

Run a benchmark:

```shell
steampipe check benchmark.TBD
```

Run a specific control:

```shell
steampipe check control.TBD
```

### Credentials

This mod uses the credentials configured in the [Steampipe Terraform plugin](https://hub.steampipe.io/plugins/turbot/).

### Configuration

No extra configuration is required.

## Get involved

* Contribute: [Terraform Repo](https://github.com/turbot/steampipe-mod-terraform-sherlock)
* Community: [Slack Channel](https://steampipe.io/community/join)
