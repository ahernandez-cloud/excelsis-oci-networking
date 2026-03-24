module "vcn_stack" {
  source = "../../modules/vcn_stack"

  compartment_id   = var.compartment_id
  drg_id           = var.drg_id
  vcn_cidr_block   = var.vcn_cidr_block
  vcn_display_name = var.vcn_display_name
  vcn_dns_label    = var.vcn_dns_label
  subnets          = var.subnets
  freeform_tags    = var.freeform_tags
}
