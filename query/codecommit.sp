query "codecommit_approval_rule_template_number_of_approval_2" {
  sql = <<-EOQ
    with number_of_approvals_needed as (
      select
        type || ' ' || name as name,
        (s -> 'NumberOfApprovalsNeeded')::int as num_of_approval
      from
        terraform_resource,
        jsonb_array_elements((arguments ->> 'content')::jsonb -> 'Statements') as s
      where
        type = 'aws_codecommit_approval_rule_template'
    )
    select
      r.type || ' ' || r.name as resource,
      case
        when num_of_approval >= 2 then 'ok'
        else 'alarm'
      end as status,
      r.name || ' number of approvals is not set to ' || num_of_approval || '.' as reason
      ${local.common_dimensions_sql}
    from
      terraform_resource as r
      left join number_of_approvals_needed as n on n.name = concat(r.type || ' ' || r.name)
    where
      r.type = 'aws_codecommit_approval_rule_template';
  EOQ
}