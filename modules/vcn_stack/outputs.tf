output "vcn_id" {
  value       = oci_core_vcn.this.id
  description = "OCID de la VCN."
}

output "internet_gateway_id" {
  value       = oci_core_internet_gateway.this.id
  description = "OCID del Internet Gateway."
}

output "nat_gateway_id" {
  value       = oci_core_nat_gateway.this.id
  description = "OCID del NAT Gateway."
}

output "service_gateway_id" {
  value       = oci_core_service_gateway.this.id
  description = "OCID del Service Gateway."
}

output "route_table_public_id" {
  value       = oci_core_route_table.public.id
  description = "OCID de la tabla de rutas pública."
}

output "route_table_private_id" {
  value       = oci_core_route_table.private.id
  description = "OCID de la tabla de rutas privada."
}

output "subnet_ids" {
  value       = { for k, s in oci_core_subnet.this : k => s.id }
  description = "Mapa nombre lógico -> OCID de subnet."
}

output "security_list_ids" {
  value       = { for k, sl in oci_core_security_list.subnet : k => sl.id }
  description = "Mapa nombre lógico -> OCID de Security List."
}

output "drg_attachment_id" {
  value       = oci_core_drg_attachment.vcn.id
  description = "OCID del adjunto VCN-DRG."
}
