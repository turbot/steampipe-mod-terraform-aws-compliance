mod "terraform_sherlock" {
  # Hub metadata
  title         = "Terraform Sherlock"
  description   = "Interrogate your Terraform resources with the help of the world's greatest detectives: Steampipe + Sherlock."
  color         = "#844FBA"
  documentation = file("./docs/index.md")
  icon          = "/images/mods/turbot/terraform-sherlock.svg"
  categories    = ["best practices", "terraform", "sherlock", "software development"]

  opengraph {
    title        = "Steampipe Mod to Analyze Terraform"
    description  = "Interrogate your Terraform resources with the help of the world's greatest detectives: Steampipe + Sherlock."
    image        = "/images/mods/turbot/terraform-sherlock-social-graphic.png"
  }

  requires {
    plugin "terraform" {
      version = "0.0.1"
    }
  }
}
