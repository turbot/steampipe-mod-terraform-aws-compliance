locals {
  iam_compliance_common_tags = merge(local.compliance_common_tags, {
    service = "iam"
  })
}

benchmark "iam" {
  title    = "IAM"
  children = [
    control.iam_account_password_policy_min_length_14,
    control.iam_account_password_policy_one_lowercase_letter,
    control.iam_account_password_policy_one_number,
    control.iam_account_password_policy_one_symbol,
    control.iam_account_password_policy_one_uppercase_letter,
    control.iam_account_password_policy_reuse_24,
    control.iam_account_password_policy_strong_min_length_8,
    control.iam_account_password_policy_strong,
    control.iam_password_policy_expire_90
  ]
  tags          = local.iam_compliance_common_tags
}
