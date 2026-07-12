resource "aws_amplify_app" "pike" {
  name           = var.app.name
  repository     = var.app.repository
  build_spec     = var.app.build_spec
  custom_headers = var.custom_headers

  dynamic "custom_rule" {
    for_each = var.custom_rules
    content {
      source = custom_rule.value.source
      status = custom_rule.value.status
      target = custom_rule.value.target
    }

  }

  environment_variables = var.environment_variables
}
