# Microservices OpenAI Prompt Example

This example demonstrates how to use the terraform-openai-prompt module to generate content for a microservices architecture with multiple service repositories.

## Usage

```bash
# Set your OpenAI API key
export OPENAI_API_KEY="your-openai-api-key"

# Initialize Terraform
terraform init

# Plan and apply
terraform plan -var="openai_api_key=$OPENAI_API_KEY"
terraform apply -var="openai_api_key=$OPENAI_API_KEY"
```

## What This Example Does

This example:

1. Sets up the terraform-openai-prompt module for an e-commerce microservices architecture with:
   - A main project prompt describing the overall architecture goals
   - Three microservice repositories with specialized prompts
   - Technology-specific tags for each service

2. Generates content for:
   - Main project architecture documentation
   - Service-specific documentation for each microservice:
     - Product service (Java/Spring Boot/MongoDB)
     - Order service (Go/PostgreSQL/Event-driven)
     - API Gateway (Node.js/Express)

3. Each service has multiple prompts to generate:
   - Basic service design and functionality
   - Advanced implementation details and optimization strategies

## Required Variables

- `project_prompt`: Overall description of the microservices architecture
- `repo_org`: GitHub organization name
- `project_name`: Base name for the project
- `openai_api_key`: Your OpenAI API key (passed as a variable)

## Notes

- This example demonstrates how the module handles different technology stacks for each service
- All generated content is accessible through Terraform outputs
- No GitHub Pro features are required to use this example