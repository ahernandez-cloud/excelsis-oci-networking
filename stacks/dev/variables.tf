variable "region" {
  type        = string
  description = "Región OCI del despliegue."
}

variable "compartment_id" {
  type        = string
  description = "OCID del compartment de la VCN DEV."
}

variable "drg_id" {
  type        = string
  description = "OCID del DRG central (output drg_id del stack stacks/drg)."
}

variable "vcn_display_name" {
  type        = string
  description = "Nombre visible de la VCN."
  default     = "excelsis-dev-vcn"
}

variable "vcn_cidr_block" {
  type        = string
  description = "CIDR de DEV."
  default     = "172.16.16.0/20"
}

variable "vcn_dns_label" {
  type        = string
  description = "Etiqueta DNS de la VCN (opcional)."
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
  description = "Subnets dinámicas para DEV."
  default = {
    private_app = {
      cidr_block = "172.16.17.0/24"
      type       = "private"
      dns_label  = "prvapp"
    }
    public_edge = {
      cidr_block = "172.16.31.0/24"
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
