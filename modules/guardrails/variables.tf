# AWS Control Tower Controls (sometimes called Guardrails) Input Variable Types
variable "organisational_unit_root_id" {
  description = "ID of aws organisational root ou"
  type        = string
}

variable "controls" {
  description = "Configuration of AWS Control Tower Guardrails for the whole organization"
  type = list(object({
    control_names           = list(string)
    organizational_unit_ids = list(string)
  }))
}
