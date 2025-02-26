output "main_readme" {
  description = "Generated README content for the main project"
  value       = module.openai_prompt
}

output "main_documentation" {
  description = "Generated documentation files for the main project"
  value       = module.openai_prompt.documentation_source
}

output "vpc_repository_content" {
  description = "Generated content for the VPC repository"
  value       = module.openai_prompt.repository_results["core-vpc"]
}

output "iam_repository_content" {
  description = "Generated content for the IAM repository"
  value       = module.openai_prompt.repository_results["iam-roles"]
}