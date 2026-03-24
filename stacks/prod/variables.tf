variable "region" {
  type        = string
  description = "Región OCI del despliegue."
}

variable "compartment_id" {
  type        = string
  description = "OCID del compartment de la VCN PROD."
}

variable "drg_id" {
  type        = string
  description = "OCID del DRG central. Obtenerlo del output drg_id tras aplicar stacks/drg (terraform output -raw drg_id o estado remoto)."
}

variable "vcn_display_name" {
  type        = string
  description = "Nombre visible de la VCN."
  default     = "excelsis-prod-vcn"
}

variable "vcn_cidr_block" {
  type        = string
  description = "CIDR de PROD."
  default     = "172.16.0.0/20"
}

variable "vcn_dns_label" {
  type        = string
  description = "Etiqueta DNS de la VCN (opcional; el módulo puede derivarla del nombre)."
  nullable    = true
  default     = null
}

variable "subnets" {
  type = map(object({
    cidr_block   = string
    type         = string
    dns_label    = string
    display_name = optional(string)
  }))
  description = "Subnets dinámicas para PROD (cada una con su Security List en el módulo)."
  default = {
    private_app = {
      cidr_block = "172.16.1.0/24"
      type       = "private"
      dns_label  = "prvapp"
    }
    public_edge = {
      cidr_block = "172.16.15.0/24"
      type       = "public"
      dns_label  = "pubedge"
    }
  }
}

variable "freeform_tags" {
  type        = map(string)
  description = "Etiquetas opcionales."
  default     = {}
}
