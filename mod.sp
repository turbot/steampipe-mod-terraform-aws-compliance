mod "terraform_aws_compliance" {
  # Hub metadata
  title         = "Terraform AWS Compliance"
  description   = "Run compliance and security controls to detect Terraform AWS resources deviating from security best practices prior to deployment in your AWS accounts."
  color         = "#844FBA"
  documentation = file("./docs/index.md")
  icon          = "/images/mods/turbot/terraform-aws-compliance-social-graphic.svg"
  categories    = ["best practices", "terraform", "software development"]

  opengraph {
    title       = "Steampipe Mod to Analyze Terraform"
    description = "Run compliance and security controls to detect Terraform AWS resources deviating from security best practices prior to deployment in your AWS accounts."
    image       = "/images/mods/turbot/terraform-aws-compliance-social-graphic.png"
  }

  requires {
    plugin "terraform" {
      version = "0.0.1"
    }
  }
}
