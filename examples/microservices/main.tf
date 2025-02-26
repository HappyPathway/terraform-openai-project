terraform {
  required_version = ">= 1.0.0"
  
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 5.0"
    }
  }
}

provider "github" {
  # Configuration would typically come from environment variables
}

module "openai_prompt" {
  source = "../.."  # Path to the root module
  
  # Required variables
  project_prompt = "A microservices architecture for an e-commerce platform focusing on scalability, resilience, and maintainability"
  repo_org       = "my-ecommerce-org"
  project_name   = "ecommerce-microservices"
  
  # Optional variables
  tags = ["microservices", "kubernetes", "docker", "api-gateway"]
  
  # Repository configurations with multiple prompts
  repository_configs = [
    {
      name = "product-service"
      tags = ["java", "spring-boot", "mongodb"]
      prompts = [
        "Create a product catalog microservice with REST API for managing product information and inventory",
        "Implement caching strategies and database optimization for high-performance product searches"
      ]
    },
    {
      name = "order-service"
      tags = ["golang", "postgres", "event-driven"]
      prompts = [
        "Design an order processing microservice that handles order creation, payment processing, and status updates",
        "Implement event-driven communication with other microservices using a message broker"
      ]
    },
    {
      name = "api-gateway"
      tags = ["nodejs", "express", "authentication"]
      prompts = [
        "Create an API gateway that provides a unified interface to all backend microservices",
        "Implement authentication, rate limiting, and request routing to appropriate microservices"
      ]
    }
  ]
}