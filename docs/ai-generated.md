# Repository Files and Topics Generation

## Base Repository Files
Each repository created by the module includes these standard files:

1. .gproj - Project configuration file
   - Can be AI-generated from project_name and repo_org
   - Controls documentation sources and workspace settings

2. CODEOWNERS
   - Can be AI-generated from team structure
   - Default pattern assigns repository to terraform-reviewers team

3. README.md
   - Can be AI-generated from repository metadata and project_prompt
   - Includes standard sections: Overview, Features, Usage, Requirements

4. Repository Configuration Files
   - .github/workflows/* - CI/CD workflow files
   - VS Code workspace settings
   - Project-specific configuration

## Repository Topics

Topics are managed through the github_repo_topics attribute in the repository configuration:

```hcl
github_repo_topics = ["terraform", "gcp", "networking", "security", "infrastructure"]
```

Common topic patterns that can be AI-generated:
- Cloud provider (aws, gcp, azure)
- Resource type (compute, storage, networking)
- Framework (terraform, kubernetes)
- Purpose (security, monitoring, infrastructure)

## AI-Generated Content Opportunities

The following can be automatically generated with minimal inputs:

1. Base Repository Structure
   - Input: project_name, repo_org
   - Output: Basic repository structure and files

2. Documentation
   - Input: project_prompt
   - Output: README.md, security docs, contribution guidelines

3. Configuration Files
   - Input: Repository purpose/type
   - Output: Workflows, settings, templates

4. Repository Topics
   - Input: Repository purpose and cloud provider
   - Output: Relevant topic tags

Required inputs for AI generation:
- project_prompt: High-level description of project purpose
- repo_org: GitHub organization name
- project_name: Base name for project repositories

## Repository Topics and Prompts Integration

### Benefits of Combined Approach

1. Enhanced Context Generation
   - Topics provide structured metadata that AI can use to categorize and understand repository purpose
   - Project-level prompts offer high-level business context and goals
   - Repository-level prompts add specific technical requirements
   - Combined, they create a rich context model for more accurate generation

2. Consistent Pattern Recognition
   - Topics establish repeatable patterns across repositories
   - Example mapping:
     ```hcl
     topics = ["terraform", "gcp", "networking"]
     project_prompt = "Infrastructure automation for GCP networking components"
     ```
   - AI can infer standard file structures and configurations based on topic combinations

3. Automated Documentation Generation
   - Topics drive technical documentation structure
   - Project prompts inform business value sections
   - Repository prompts detail implementation specifics
   - Results in comprehensive, well-organized documentation

4. Template Selection
   - Topics help select appropriate base templates
   - Prompts customize template content
   - Example:
     - Topics: ["terraform", "aws", "security"]
     - Project: "Cloud security automation framework"
     - Repo: "IAM policy management module"
     - Generated: Security-focused README, IAM-specific examples

5. Intelligent Defaults
   - Topics set baseline configuration:
     - CI/CD workflow selection
     - Default branch protection rules
     - Required status checks
   - Prompts refine these defaults with project-specific needs

### Implementation Strategy

1. Define Topic Hierarchy
   ```hcl
   github_repo_topics = [
     "framework:terraform",    # Technology stack
     "cloud:gcp",             # Platform
     "type:networking",       # Resource type
     "category:infrastructure" # Purpose
   ]
   ```

2. Structure Prompts
   ```hcl
   project_prompt = <<EOT
   Cloud infrastructure automation focusing on GCP networking components
   with emphasis on security and scalability.
   EOT

   repository_prompt = <<EOT
   VPC and subnet management module supporting multi-region deployments
   with automated peering configuration.
   EOT
   ```

3. AI Generation Process
   a. Parse topics for basic repository structure
   b. Apply project prompt for high-level organization
   c. Use repository prompt for specific implementations
   d. Generate documentation incorporating all contexts

### Minimum Required Inputs

For effective AI generation using combined approach:

1. Essential Topics
   - Framework/language tag
   - Cloud provider (if applicable)
   - Resource type or main function
   - Category/purpose tag

2. Project Prompt Components
   - Overall goal/purpose
   - Key requirements
   - Target audience

3. Repository Prompt Elements
   - Specific functionality
   - Technical constraints
   - Integration requirements

Example Minimal Configuration:
```hcl
module "repository" {
  # ...existing configuration...

  github_repo_topics = ["terraform", "gcp", "networking", "infrastructure"]
  
  project_prompt = "GCP infrastructure automation framework"
  
  repository_prompt = "Network management module for VPC and subnets"
}
```

### Benefits for Non-Pro GitHub Usage

1. Public Repository Optimization
   - Topics improve repository discoverability
   - Generated documentation focuses on public consumption
   - Automated template selection respects public repo limitations

2. Community Engagement
   - Topics help potential contributors find repositories
   - AI-generated contributing guidelines based on topic patterns
   - Project/repo prompts create clear purpose documentation

3. Maintenance Efficiency
   - Standardized structure across repositories
   - Automated updates based on topic patterns
   - Consistent documentation format

## Documentation Source Generation

The module can automatically generate documentation sources based on repository topics and prompts. Here's how it maps:

1. Topic-Based Documentation Sources
   - Framework topics (terraform, golang, python) -> Language/framework documentation
   - Cloud provider topics (gcp, aws) -> Provider documentation 
   - Infrastructure topics -> Architecture documentation

Example mapping:
```hcl
# For a repository with these topics:
github_repo_topics = ["terraform", "gcp", "networking"]

# Generated documentation sources:
documentation_sources = [
  {
    repo = "https://github.com/hashicorp/terraform"
    name = "docs/terraform/language"
    path = "website/docs/language"
  },
  {
    repo = "https://github.com/hashicorp/terraform-provider-google" 
    name = "docs/provider/google/networking"
    path = "website/docs/r"
  }
]
```

2. Prompt-Based Documentation

The project_prompt and repository-specific prompts can enhance documentation sources by:
- Identifying required provider documentation sections
- Determining necessary framework documentation
- Identifying relevant examples and tutorials

Example:
```hcl
project_prompt = "GCP infrastructure automation with security focus"
github_repo_topics = ["terraform", "gcp", "security"]

# Generated additional sources:
documentation_sources = [
  // ...base sources from topics...
  {
    repo = "https://github.com/hashicorp/terraform-provider-google"
    name = "docs/provider/google/guides/security"
    path = "website/docs/guides/security"
  }
]
```

3. Documentation Source Validation
- Sources are validated for public accessibility (GitHub Pro not required)
- Documentation paths are checked against repository structure
- Sources are deduplicated if specified in multiple ways

4. Implementation Notes
- Keep documentation sources focused and minimal
- Prefer official documentation sources
- Ensure all sources are publicly accessible
- Documentation paths should map to standard repository layouts

5. Required Inputs
```hcl
project_prompt     = "High-level description of project purpose"
github_repo_topics = ["framework", "platform", "category"]
repo_org          = "organization-name"
```

The generated documentation sources provide:
- Framework/language reference documentation
- Provider-specific guides and resources
- Relevant tutorials and examples
- Security and compliance documentation
- Architecture patterns and best practices

This approach ensures that documentation sources are:
- Relevant to the repository purpose
- Properly scoped to project needs
- Accessible without GitHub Pro
- Maintainable and updateable

## Workspace Settings and Extensions Generation

The module can automatically generate VS Code workspace settings and suggest extensions based on repository topics and project prompts. Here's how:

1. Topic-Based Extension Mapping
   ```hcl
   locals {
     topic_extension_mappings = {
       "terraform" = ["hashicorp.terraform", "hashicorp.hcl"]
       "python" = ["ms-python.python", "ms-python.vscode-pylance"]
       "javascript" = ["dbaeumer.vscode-eslint", "esbenp.prettier-vscode"]
       "typescript" = ["ms-typescript-javascript.typescript-javascript"]
       // Basic mappings only - avoid adding too many extensions
     }
   }
   ```

2. Default Settings Generation
   ```hcl
   locals {
     default_vscode_settings = {
       "editor.formatOnSave": true,
       "editor.rulers": [80, 120],
       "files.exclude": {
         "**/.git": true,
         "**/.DS_Store": true
       },
       "workbench.iconTheme": "vscode-icons",
       "editor.inlineSuggest.enabled": true
     }
   }
   ```

3. Prompt-Based Configuration
   - Project prompts inform specific editor settings
   - Repository prompts influence language-specific configurations
   - Example:
     ```hcl
     project_prompt = "Python-based machine learning project"
     // Generates settings like:
     {
       "[python]": {
         "editor.formatOnSave": true,
         "editor.defaultFormatter": "ms-python.python"
       }
     }
     ```

4. Extension Generation Process
   a. Extract topics from repositories
   b. Map topics to recommended extensions
   c. Remove duplicates
   d. Combine with prompt-based suggestions
   e. Add essential development tools

5. Configuration Principles
   - Keep extension list minimal
   - Prefer widely-used, well-maintained extensions
   - Avoid extensions requiring GitHub Pro
   - Focus on development essentials

Example Implementation:
```hcl
module "github_project" {
  source = "path/to/module"

  project_name = "my-project"
  project_prompt = "Infrastructure as Code using Terraform and Python"
  
  repositories = [
    {
      name = "infra-core"
      github_repo_topics = ["terraform", "python"]
      prompt = "Core infrastructure modules"
    }
  ]

  # Optional: Override auto-generated settings
  vs_code_workspace = {
    settings = {
      # Only override what you need
      "editor.formatOnSave": true
    }
    extensions = {
      # Add specific extensions not covered by topics
      recommended = ["eamodio.gitlens"]
    }
  }
}
```

Generated Output:
1. Workspace Settings File (.code-workspace)
   - Project-wide settings
   - Repository paths
   - Extension recommendations
   - Language-specific configurations

2. Editor Configuration (.editorconfig)
   - Basic formatting rules
   - Line endings
   - Indentation settings

3. Default Launch Configurations
   - Debug settings for detected languages
   - Test runners
   - Common development tasks

Benefits:
- Consistent development environment
- Automated configuration
- No dependency on GitHub Pro
- Team-wide standardization
- Minimal maintenance required

Usage Notes:
- Keep repository topics focused and accurate
- Use clear, descriptive project prompts
- Override only necessary settings
- Test with public repositories first
- Validate extension compatibility
````
