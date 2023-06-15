// Benchmarks and controls for specific services should override the "service" tag
locals {
  terraform_aws_compliance_common_tags = {
    category = "Compliance"
    plugin   = "terraform"
    service  = "AWS"
  }
}

variable "common_dimensions" {
  type        = list(string)
  description = "A list of common dimensions to add to each control."
  # Define which common dimensions should be added to each control.
  # - connection_name (_ctx ->> 'connection_name')
  # - path
  default     = ["path"]
}

variable "tag_dimensions" {
  type        = list(string)
  description = "A list of tags to add as dimensions to each control."
  # A list of tag names to include as dimensions for resources that support
  # tags (e.g. "Owner", "Environment"). Default to empty since tag names are
  # a personal choice - for commonly used tag names see
  # https://docs.aws.amazon.com/general/latest/gr/aws_tagging.html#tag-categories
  default     = ["name", "foo"]
}

locals {

  # Local internal variable to build the SQL select clause for common
  # dimensions using a table name qualifier if required. Do not edit directly.
  common_dimensions_qualifier_sql = <<-EOQ
  %{~ if contains(var.common_dimensions, "connection_name") }, __QUALIFIER___ctx ->> 'connection_name' as connection_name%{ endif ~}
  %{~ if contains(var.common_dimensions, "path") }, __QUALIFIER__path || ':' || __QUALIFIER__start_line%{ endif ~}
  EOQ

  # Local internal variable to build the SQL select clause for tag
  # dimensions. Do not edit directly.
  tag_dimensions_qualifier_sql = <<-EOQ
  %{~ for dim in var.tag_dimensions },  __QUALIFIER__arguments -> 'tags' ->> '${dim}' as "${replace(dim, "\"", "\"\"")}"%{ endfor ~}
  EOQ

}

locals {

  # Local internal variable with the full SQL select clause for common
  # dimensions. Do not edit directly.
  common_dimensions_sql = replace(local.common_dimensions_qualifier_sql, "__QUALIFIER__", "")
  tag_dimensions_sql = replace(local.tag_dimensions_qualifier_sql, "__QUALIFIER__", "")

}

mod "terraform_aws_compliance" {
  # Hub metadata
  title         = "Terraform AWS Compliance"
  description   = "Run compliance and security controls to detect Terraform AWS resources deviating from security best practices prior to deployment in your AWS accounts."
  color         = "#844FBA"
  documentation = file("./docs/index.md")
  icon          = "/images/mods/turbot/terraform-aws-compliance.svg"
  categories    = ["aws", "compliance", "iac", "security", "terraform"]

  opengraph {
    title       = "Steampipe Mod to Analyze Terraform"
    description = "Run compliance and security controls to detect Terraform AWS resources deviating from security best practices prior to deployment in your AWS accounts."
    image       = "/images/mods/turbot/terraform-aws-compliance-social-graphic.png"
  }

  requires {
    plugin "terraform" {
      version = "0.0.5"
    }
  }
}
