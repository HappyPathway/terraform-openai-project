# Basic OpenAI Prompt Example

This example demonstrates how to use the terraform-openai-prompt module to generate content for multiple repositories based on prompts and tags.

## Usage

```bash
# Set your OpenAI API key
export OPENAI_API_KEY="your-openai-api-key"

# Set your GitHub token (not required for content generation, only if you want to create repos)
export GITHUB_TOKEN="your-github-token"

# Initialize Terraform
terraform init

# Run Terraform plan to see what will be created
terraform plan -var="openai_api_key=$OPENAI_API_KEY"

# Apply the configuration
terraform apply -var="openai_api_key=$OPENAI_API_KEY"
```

## What This Example Does

This example:

1. Sets up the terraform-openai-prompt module with:
   - A main project prompt about AWS security infrastructure
   - Two repository configurations (VPC and IAM) with multiple prompts each
   - Relevant tags for both the main project and specific repositories

2. Generates AI content for:
   - Main project README and documentation
   - Repository-specific content for "core-vpc" and "iam-roles" based on their prompts

3. Outputs:
   - Generated README content for the main project
   - Generated documentation files
   - Repository-specific content for VPC and IAM repositories

## Required Variables

- `project_prompt`: High-level description of the project purpose
- `repo_org`: GitHub organization name
- `project_name`: Base name for the project repositories
- `openai_api_key`: Your OpenAI API key (should be passed as a variable)

## Notes

- This example works with GitHub Free tier - no GitHub Pro features required
- Multiple prompts per repository allow for more comprehensive content generation
- The generated content is accessible through Terraform outputs