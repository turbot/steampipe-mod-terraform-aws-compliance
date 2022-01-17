mod "terraform_aws_compliance" {
  # Hub metadata
  title         = "Terraform AWS Compliance"
  description   = "Lightweight, security and compliance-focused framework for Terraform. Run individual configuration, compliance and security controls for individual AWS services across all your AWS accounts using Steampipe."
  color         = "#844FBA"
  documentation = file("./docs/index.md")
  icon          = "/images/mods/turbot/terraform-sherlock.svg"
  categories    = ["best practices", "terraform", "sherlock", "software development"]

  opengraph {
    title       = "Steampipe Mod to Analyze Terraform"
    description = "Lightweight, security and compliance-focused framework for Terraform. Run individual configuration, compliance and security controls for individual AWS services across all your AWS accounts using Steampipe."
    image       = "/images/mods/turbot/terraform-sherlock-social-graphic.png"
  }

  # requires {
  #   plugin "terraform" {
  #     version = "0.0.1"
  #   }
  # }
}
