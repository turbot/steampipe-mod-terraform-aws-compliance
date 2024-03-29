query "codecommit_approval_rule_template_number_of_approval_2" {
  sql = <<-EOQ
    with number_of_approvals_needed as (
      select
        address as name,
        (s -> 'NumberOfApprovalsNeeded')::int as num_of_approval
      from
        terraform_resource,
        jsonb_array_elements((attributes_std ->> 'content')::jsonb -> 'Statements') as s
      where
        type = 'aws_codecommit_approval_rule_template'
    )
    select
      r.address as resource,
      case
        when num_of_approval >= 2 then 'ok'
        else 'alarm'
      end as status,
      split_part(r.address, '.', 2) || ' number of approvals is set to ' || num_of_approval || '.' as reason
      ${local.common_dimensions_sql}
    from
      terraform_resource as r
      left join number_of_approvals_needed as n on n.name = r.address
    where
      r.type = 'aws_codecommit_approval_rule_template';
  EOQ
}