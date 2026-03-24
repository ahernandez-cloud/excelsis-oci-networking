module "drg" {
  source = "../../modules/drg"

  compartment_id = var.compartment_id
  display_name   = var.drg_display_name
  freeform_tags  = var.freeform_tags
}
