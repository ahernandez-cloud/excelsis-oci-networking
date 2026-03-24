output "drg_id" {
  description = "OCID del DRG; requerido por los stacks de VCN (variable drg_id)."
  value       = oci_core_drg.this.id
}
