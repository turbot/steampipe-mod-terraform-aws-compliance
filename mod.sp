mod "terraform_aws_compliance" {
  # Hub metadata
  title         = "Terraform AWS Compliance"
  description   = "Lightweight, security and compliance-focused framework for Terraform. Run individual configuration, compliance and security controls for individual AWS services across all your AWS accounts using Steampipe."
  color         = "#844FBA"
  documentation = file("./docs/index.md")
  icon          = "/images/mods/turbot/terraform-aws-compliance-social-graphic.svg"
  categories    = ["best practices", "terraform", "software development"]

  opengraph {
    title       = "Steampipe Mod to Analyze Terraform"
    description = "Lightweight, security and compliance-focused framework for Terraform. Run individual configuration, compliance and security controls for individual AWS services across all your AWS accounts using Steampipe."
    image       = "/images/mods/turbot/terraform-aws-compliance-social-graphic.png"
  }

  # requires {
  #   plugin "terraform" {
  #     version = "0.0.1"
  #   }
  # }
}
