variable "compartment_id" {
  type        = string
  description = "OCID del compartment donde se crea el DRG."
}

variable "display_name" {
  type        = string
  description = "Nombre visible del Dynamic Routing Gateway."
}

variable "freeform_tags" {
  type        = map(string)
  description = "Etiquetas libres opcionales."
  default     = {}
}
