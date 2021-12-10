mod "terraform_aws_compliance" {
  # Hub metadata
  title         = "Terraform AWS Compliance"
  description   = "Run individual controls or full compliance benchmarks for CIS, PCI, NIST, HIPAA and more across all of your Terraform AWS resources using Steampipe."
  color         = "#844FBA"
  documentation = file("./docs/index.md")
  icon          = "/images/mods/turbot/terraform-aws-compliance.svg"
  categories    = ["terraform", "aws", "cis", "compliance", "public cloud", "security"]

  opengraph {
    title        = "Steampipe Mod for Terraform AWS Compliance"
    description  = "Run individual controls or full compliance benchmarks for CIS, PCI, NIST, HIPAA and more across all of your Terraform AWS resources using Steampipe."
    image        = "/images/mods/turbot/terraform-aws-compliance-social-graphic.png"
  }

  requires {
    plugin "terraform" {
      version = "0.0.1"
    }
  }
}
