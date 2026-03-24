resource "oci_core_drg" "this" {
  compartment_id = var.compartment_id
  display_name   = var.display_name
  freeform_tags  = var.freeform_tags
}
