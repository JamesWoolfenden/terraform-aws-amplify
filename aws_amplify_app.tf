resource "aws_amplify_app" "pike" {
  name       = var.app.name
  repository = var.app.repository
  build_spec = var.app.build_spec

  dynamic "custom_rule" {
    for_each=var.custom_rules
    content {
        source = custom_rule.value.source
        status = custom_rule.value.status
        target = custom_rule.value.target
    }
    
  }

  environment_variables = var.app.environment_variables
  tags = var.tags
}

variable "app" {
  type = object({
    name       = string
    repository = string
    build_spec = string
    environment_variables=map(string)
  })
  default = {
    build_spec = <<-EOT
    version: 0.1
    frontend:
      phases:
        preBuild:
          commands:
            - yarn install
        build:
          commands:
            - yarn run build
      artifacts:
        baseDirectory: build
        files:
          - '**/*'
      cache:
        paths:
          - node_modules/**/*
  EOT
    environment_variables = {
        ENV = "test"
    }
    name = "pike"
    repository = "https://github.com/hortonworks/simple-yarn-app"
  }
}

variable "custom_rules" {
  type = list(object({
    source = string
    status = string
    target = string
  }))
  default = [ {
    source = "/<*>"
    status = "404"
    target = "/index.html"
  } ]
}

