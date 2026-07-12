
variable "app" {
  type = object({
    name       = string
    repository = string
    build_spec = string
  })
  description = "Application configuration for the Amplify app"
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
    name       = "pike"
    repository = "https://github.com/hortonworks/simple-yarn-app"
  }

  validation {
    condition     = length(var.app.name) > 0 && length(regex("^https?://", var.app.repository)) > 0
    error_message = "app.name must not be empty and app.repository must be a valid http(s) URL"
  }
}

variable "environment_variables" {
  type        = map(string)
  description = "Environment variables for the Amplify build. Marked sensitive: Amplify has no secrets manager for these values, so do not rely on this for real secrets — reference AWS SSM Parameter Store or Secrets Manager from build_spec commands instead."
  sensitive   = true
  default = {
    ENV = "test"
  }

  validation {
    condition     = alltrue([for k in keys(var.environment_variables) : length(k) > 0])
    error_message = "environment_variables keys must not be empty strings."
  }
}

variable "custom_headers" {
  type        = string
  description = "Custom HTTP response headers (Amplify customHeaders YAML) applied to every response, e.g. CSP, HSTS, X-Frame-Options."
  default     = <<-EOT
  customHeaders:
    - pattern: '**'
      headers:
        - key: 'Strict-Transport-Security'
          value: 'max-age=31536000; includeSubDomains'
        - key: 'X-Frame-Options'
          value: 'SAMEORIGIN'
        - key: 'X-Content-Type-Options'
          value: 'nosniff'
        - key: 'Content-Security-Policy'
          value: "default-src 'self'"
  EOT

  validation {
    condition     = length(var.custom_headers) > 0
    error_message = "custom_headers must not be empty."
  }
}

variable "custom_rules" {
  type = list(object({
    source = string
    status = string
    target = string
  }))
  description = "List of custom rewrite/redirect rules for the Amplify app"
  default = [{
    source = "/<*>"
    status = "404"
    target = "/index.html"
  }]

  validation {
    condition     = alltrue([for r in var.custom_rules : length(r.source) > 0 && length(r.target) > 0 && length(regexall("^\\d{3}$", r.status)) > 0])
    error_message = "Each custom_rules entry must have non-empty source and target and status must be a 3-digit string (e.g. \"200\", \"301\", \"404\")."
  }
}
