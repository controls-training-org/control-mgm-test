
//Import guardrails as bloc
locals {
  //OU ARN
  target_identifier = "arn:aws:organizations::200223571282:ou/o-x9clds5k02/ou-oqgn-17e9npip"

  //ARN of Guardrail -> https://docs.aws.amazon.com/controltower/latest/controlreference/control-metadata-tables.html
  guardrails = {
    guardrail_test = {
      control_identifier = "arn:aws:controlcatalog:::control/5mhjhod4ky44haldvja2v4x3a" # CT.APIGATEWAY.PR.1
    }
    guardrail_2 = {
      control_identifier = "arn:aws:controltower:eu-west-1::control/AWS-GR_LAMBDA_CHANGE_PROHIBITED" # AWS-GR_LAMBDA_CHANGE_PROHIBITED
    }
    guardrail_3 = {
      control_identifier = "arn:aws:controlcatalog:::control/e2saoisw5u8xe40acfetio41w" # AWS-GR_CONFIG_CHANGE_PROHIBITED
    }
  }

}

resource "aws_controltower_control" "guardrails" {
  for_each           = local.guardrails
  control_identifier = each.value.control_identifier
  target_identifier  = local.target_identifier
}

import {
  for_each = local.guardrails
  id       = "${local.target_identifier},${each.value.control_identifier}"
  to       = aws_controltower_control.guardrails[each.key]
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


