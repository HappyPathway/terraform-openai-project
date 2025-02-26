terraform {
  required_version = ">= 1.0.0"
}

variable openai_api_key {
    description = "OpenAI API key for authentication"
    type        = string
    sensitive   = true
}
provider "github" {
  # Configuration would typically come from environment variables:
  # GITHUB_TOKEN
  # GITHUB_OWNER (optional)
}

module "openai_prompt" {
  source = "../.."  # Path to the root module
  
  # Required variables
  project_prompt = "A Terraform module for automating AWS infrastructure deployment focusing on security best practices and cost optimization"
  repo_org       = "my-github-organization"
  project_name   = "terraform-aws-secure-infra"
  
  # Optional variables
  tags = ["terraform", "aws", "security", "infrastructure"]
  openai_api_key = var.openai_api_key
  # Repository configurations with multiple prompts
  repository_configs = [
    {
      name = "core-vpc"
      tags = ["networking", "vpc", "subnets"]
      prompts = [
        "Design a secure VPC architecture with public and private subnets across multiple availability zones",
        "Implement network ACLs and security groups following best practices for AWS networking"
      ]
    },
    {
      name = "iam-roles"
      tags = ["iam", "security", "roles"]
      prompts = [
        "Create IAM roles and policies following the principle of least privilege",
        "Implement cross-account access patterns for secure multi-account deployments"
      ]
    }
  ]
}