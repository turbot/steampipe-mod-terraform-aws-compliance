mod "terraform_aws_compliance" {
  # Hub metadata
  title         = "Terraform AWS Compliance"
  description   = "Run compliance and security controls to detect Terraform AWS resources deviating from security best practices prior to deployment in your AWS accounts using Powerpipe and Steampipe.."
  color         = "#844FBA"
  documentation = file("./docs/index.md")
  icon          = "/images/mods/turbot/terraform-aws-compliance.svg"
  categories    = ["aws", "compliance", "iac", "security", "terraform"]

  opengraph {
    title       = "Powerpipe Mod to Analyze Terraform"
    description = "Run compliance and security controls to detect Terraform AWS resources deviating from security best practices prior to deployment in your AWS accounts using Powerpipe and Steampipe.."
    image       = "/images/mods/turbot/terraform-aws-compliance-social-graphic.png"
  }

  requires {
    plugin "terraform" {
      min_version = "0.10.0"
    }
  }
}
