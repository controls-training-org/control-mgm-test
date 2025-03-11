#invoke guardrail module
module "control_tower_guardrails" {
  count                       = var.enable_guardrails_module ? 1 : 0
  source                      = "./modules/guardrails"
  organisational_unit_root_id = var.organisational_unit_root_id
  controls                    = var.controls
}

