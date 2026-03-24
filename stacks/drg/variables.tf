variable "region" {
  type        = string
  description = "Región OCI (por ejemplo us-ashburn-1). Suele alinearse con OCI_CLI_REGION o la config del CLI."
}

variable "compartment_id" {
  type        = string
  description = "OCID del compartment donde se despliega el DRG."
}

variable "drg_display_name" {
  type        = string
  description = "Nombre visible del DRG."
  default     = "excelsis-central-drg"
}

variable "freeform_tags" {
  type        = map(string)
  description = "Etiquetas opcionales para el DRG."
  default     = {}
}
