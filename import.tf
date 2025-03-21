
//Import guardrails as bloc
locals {
  //OU ARN
  target_identifier = "arn:aws:organizations::200223571282:ou/o-x9clds5k02/ou-oqgn-17e9npip"

  //ARN of Guardrail -> https://docs.aws.amazon.com/controltower/latest/controlreference/control-metadata-tables.html
  # Guardrails which can be destroyed
  guardrails_destroyable = {
    guardrail_test = {
      control_identifier = "arn:aws:controlcatalog:::control/5mhjhod4ky44haldvja2v4x3a" # CT.APIGATEWAY.PR.1
    }
    guardrail_11 = {
      control_identifier = "arn:aws:controlcatalog:::control/8zfd7nm6xbeevojp7yw6ihgo6" # AUTOSCALING_CAPACITY_REBALANCING
    }
  }

  # Guardrails which cannot be destroyed (Mandatory guardrails)
  guardrails_protected = {
    guardrail_2 = {
      control_identifier = "arn:aws:controltower:eu-west-1::control/AWS-GR_LAMBDA_CHANGE_PROHIBITED" # AWS-GR_LAMBDA_CHANGE_PROHIBITED
    }
    guardrail_10 = {
      control_identifier = "arn:aws:controltower:eu-west-1::control/AWS-GR_CONFIG_AGGREGATION_AUTHORIZATION_POLICY" # AWS-GR_CONFIG_AGGREGATION_AUTHORIZATION_POLICY
    }
  }
}

# Resource for destroyable guardrails
resource "aws_controltower_control" "destroyable_guardrails" {
  for_each           = local.guardrails_destroyable
  control_identifier = each.value.control_identifier
  target_identifier  = local.target_identifier

  lifecycle {
    prevent_destroy = false
  }
}

# Resource for protected guardrails
resource "aws_controltower_control" "protected_guardrails" {
  for_each           = local.guardrails_protected
  control_identifier = each.value.control_identifier
  target_identifier  = local.target_identifier

  lifecycle {
    prevent_destroy = true
  }
}

# Import blocks for destroyable guardrails
import {
  for_each = local.guardrails_destroyable
  id       = "${local.target_identifier},${each.value.control_identifier}"
  to       = aws_controltower_control.destroyable_guardrails[each.key]
}

# Import blocks for protected guardrails
import {
  for_each = local.guardrails_protected
  id       = "${local.target_identifier},${each.value.control_identifier}"
  to       = aws_controltower_control.protected_guardrails[each.key]
}

/*
//This code works to import one guardrail at a time
resource "aws_controltower_control" "guardrails_import_1" {
    control_identifier = "arn:aws:controltower:eu-west-1::control/YPSCUERHMDGL" # CT.CLOUDWATCH.PR.1
    target_identifier = "arn:aws:organizations::200223571282:ou/o-x9clds5k02/ou-oqgn-17e9npip"
    }

import {  
  to = aws_controltower_control.guardrails_import_1
  id = "arn:aws:organizations::200223571282:ou/o-x9clds5k02/ou-oqgn-17e9npip,arn:aws:controltower:eu-west-1::control/YPSCUERHMDGL"
  }
*/


