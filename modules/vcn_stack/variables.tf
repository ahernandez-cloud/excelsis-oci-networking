variable "compartment_id" {
  type        = string
  description = "OCID del compartment de la VCN y recursos asociados."
}

variable "drg_id" {
  type        = string
  description = "OCID del DRG central (salida drg_id del stack stacks/drg). No usar OCIDs fijos en código."
}

variable "vcn_cidr_block" {
  type        = string
  description = "CIDR principal de la VCN (un solo bloque)."
}

variable "vcn_display_name" {
  type        = string
  description = "Nombre visible de la VCN."
}

variable "vcn_dns_label" {
  type        = string
  description = "Etiqueta DNS de la VCN (minúsculas, alfanumérico; opcional)."
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
  description = "Subnets dinámicas. type = public | private. Cada entrada tiene su propia Security List."

  validation {
    condition = alltrue([
      for _, s in var.subnets : contains(["public", "private"], s.type)
    ])
    error_message = "Cada subnet.type debe ser \"public\" o \"private\"."
  }
}

variable "freeform_tags" {
  type        = map(string)
  description = "Etiquetas libres para la VCN y recursos que las soporten."
  default     = {}
}
