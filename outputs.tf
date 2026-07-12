output "app_id" {
  value       = aws_amplify_app.pike.id
  description = "The ID of the Amplify App"
}

output "app_arn" {
  value       = aws_amplify_app.pike.arn
  description = "The ARN of the Amplify App"
}

output "default_domain" {
  value       = aws_amplify_app.pike.default_domain
  description = "The default domain for the Amplify App"
}
