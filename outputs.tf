output "readme_content" {
  description = "Generated README content from OpenAI for the main project"
  value       = local.main_response.readme_content
}

output "best_practices" {
  description = "List of best practices for the project"
  value       = local.main_response.best_practices
}

output "suggested_extensions" {
  description = "Suggested VS Code extensions for the project"
  value       = local.main_response.suggested_extensions
}

output "documentation_source" {
  description = "List of documentation sources to clone"
  value       = local.main_response.documentation_source
}

output "copilot_instructions" {
  description = "Generated copilot instructions content"
  value       = local.main_response.copilot_instructions
}

output "repository_results" {
  description = "Generated content for each repository configuration and prompt"
  value       = local.repository_results
}

output "documentation_sources" {
  description = "List of documentation sources to clone in the format expected by downstream modules"
  value = [
    for source in try(local.main_response.documentation_source, []) : {
      repo = source
      name = basename(source)
      path = "."
      tag  = "main"
    }
  ]
}

output "repository_files" {
  description = "Map of repositories to their files and content for easy consumption"
  value = {
    for repo_name, repo_content in local.repository_results : repo_name => {
      "README.md" = {
        content = try(repo_content[0].readme_content, "# ${repo_name}\nRepository content not generated")
        path    = "README.md"
      }
      ".vscode/extensions.json" = {
        content = jsonencode({
          recommendations = try(repo_content[0].suggested_extensions, [])
        })
        path = ".vscode/extensions.json"
      }
      "docs/BEST_PRACTICES.md" = {
        content = join("\n\n", [
          "# Best Practices",
          join("\n", [for practice in try(repo_content[0].best_practices, []) : "- ${practice}"])
        ])
        path = "docs/BEST_PRACTICES.md"
      }
      "docs/SOURCES.md" = {
        content = join("\n\n", [
          "# Documentation Sources",
          join("\n", [for source in try(repo_content[0].documentation_source, []) : "- ${source}"])
        ])
        path = "docs/SOURCES.md"
      }
    }
  }
}

output "repository_documentation_sources" {
  description = "Map of repositories to their documentation sources in the format expected by downstream modules"
  value = {
    for repo_name, repo_content in local.repository_results : repo_name => [
      for source in try(repo_content[0].documentation_source, []) : {
        repo = source
        name = basename(source)
        path = "."
        tag  = "main"
      }
    ]
  }
}

output "main_files" {
  description = "Map of main project files and content"
  value = {
    "README.md" = {
      content = try(local.main_response.readme_content, "# Project\nMain project content not generated")
      path    = "README.md"
    }
    ".vscode/extensions.json" = {
      content = jsonencode({
        recommendations = try(local.main_response.suggested_extensions, [])
      })
      path = ".vscode/extensions.json"
    }
    "docs/BEST_PRACTICES.md" = {
      content = join("\n\n", [
        "# Best Practices",
        join("\n", [for practice in try(local.main_response.best_practices, []) : "- ${practice}"])
      ])
      path = "docs/BEST_PRACTICES.md"
    }
    "docs/SOURCES.md" = {
      content = join("\n\n", [
        "# Documentation Sources",
        join("\n", [for source in try(local.main_response.documentation_source, []) : "- ${source}"])
      ])
      path = "docs/SOURCES.md"
    }
    ".github/CODEOWNERS" = {
      content = "* @${var.repo_org}/terraform-reviewers"
      path    = ".github/CODEOWNERS"
    }
    ".github/copilot-instructions.md" = {
      content = try(local.main_response.copilot_instructions, "# GitHub Copilot Instructions\nInstructions not generated")
      path    = ".github/copilot-instructions.md"
    }
  }
}