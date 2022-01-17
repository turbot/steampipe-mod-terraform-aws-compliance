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

control "iam_account_password_policy_min_length_14" {
  title       = "Ensure IAM password policy requires minimum length of 14 or greate"
  description = "Password policies are, in part, used to enforce password complexity requirements. IAM password policies can be used to ensure password are at least a given length. It is recommended that the password policy require a minimum password length 14."
  sql           = query.iam_account_password_policy_min_length_14.sql

  tags = local.iam_compliance_common_tags
}

control "iam_account_password_policy_one_lowercase_letter" {
  title       = "Ensure IAM password policy requires at least one lowercase letter"
  description = "Password policies, in part, enforce password complexity requirements. Use IAM password policies to ensure that passwords use different character sets. Security Hub recommends that the password policy require at least one lowercase letter. Setting a password complexity policy increases account resiliency against brute force login attempts."
  sql           = query.iam_account_password_policy_one_lowercase_letter.sql

  tags = local.iam_compliance_common_tags
}

control "iam_account_password_policy_one_number" {
  title       = "Ensure IAM password policy requires at least one number"
  description = "Password policies, in part, enforce password complexity requirements. Use IAM password policies to ensure that passwords use different character sets."
  sql           = query.iam_account_password_policy_one_number.sql

  tags = local.iam_compliance_common_tags
}

control "iam_account_password_policy_one_symbol" {
  title       = "Ensure IAM password policy requires at least one symbol"
  description = "Password policies, in part, enforce password complexity requirements. Use IAM password policies to ensure that passwords use different character sets. Security Hub recommends that the password policy require at least one symbol. Setting a password complexity policy increases account resiliency against brute force login attempts."
  sql           = query.iam_account_password_policy_one_symbol.sql

  tags = local.iam_compliance_common_tags
}

control "iam_account_password_policy_one_uppercase_letter" {
  title       = "Ensure IAM password policy requires at least one uppercase letter"
  description = "Password policies, in part, enforce password complexity requirements. Use IAM password policies to ensure that passwords use different character sets."
  sql           = query.iam_account_password_policy_one_uppercase_letter.sql

  tags = local.iam_compliance_common_tags
}

control "iam_account_password_policy_reuse_24" {
  title       = "Ensure IAM password policy prevents password reuse"
  description = "This control checks whether the number of passwords to remember is set to 24. The control fails if the value is not 24. IAM password policies can prevent the reuse of a given password by the same user."
  sql           = query.iam_account_password_policy_reuse_24.sql

  tags = local.iam_compliance_common_tags
}

control "iam_account_password_policy_strong_min_length_8" {
  title         = "Ensure IAM password policy requires a minimum length of 8 or greater"
  description   = "This control checks whether the account password policy for IAM users uses the recommended configurations."
  severity      = "medium"
  sql           = query.iam_account_password_policy_strong_min_length_8.sql

  tags = local.iam_compliance_common_tags
}

control "iam_account_password_policy_strong" {
  title       = "Password policies for IAM users should have strong configurations"
  description = "This control checks whether the account password policy for IAM users have strong configurations."
  sql           = query.iam_account_password_policy_strong.sql

  tags = local.iam_compliance_common_tags
}

control "iam_password_policy_expire_90" {
  title       = "Ensure IAM password policy expires passwords within 90 days or less"
  description = "IAM password policies can require passwords to be rotated or expired after a given number of days. Security Hub recommends that the password policy expire passwords after 90 days or less. Reducing the password lifetime increases account resiliency against brute force login attempts."
  sql           = query.iam_password_policy_expire_90.sql

  tags = local.iam_compliance_common_tags
}