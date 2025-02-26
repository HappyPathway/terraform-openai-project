output "project_readme" {
  description = "Generated README content for the main e-commerce microservices project"
  value       = module.openai_prompt.readme_content
}

output "project_structure" {
  description = "Suggested structure for the microservices architecture"
  value       = module.openai_prompt.suggested_structure
}

output "product_service" {
  description = "Generated content for the product service"
  value       = module.openai_prompt.repository_results["product-service"]
}

output "order_service" {
  description = "Generated content for the order service"
  value       = module.openai_prompt.repository_results["order-service"]
}

output "api_gateway" {
  description = "Generated content for the API gateway"
  value       = module.openai_prompt.repository_results["api-gateway"]
}