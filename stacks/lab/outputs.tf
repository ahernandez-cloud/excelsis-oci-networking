output "vcn_id" {
  value = module.vcn_stack.vcn_id
}

output "subnet_ids" {
  value = module.vcn_stack.subnet_ids
}

output "drg_attachment_id" {
  value = module.vcn_stack.drg_attachment_id
}
