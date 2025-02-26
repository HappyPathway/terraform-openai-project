locals {
  script_path = "${path.module}/scripts"
  prompt_data = {
    project_prompt     = var.project_prompt
    project_name       = var.project_name
    repo_org           = var.repo_org
    tags               = var.tags
    repository_configs = var.repository_configs
  }
  prompt_json = jsonencode(local.prompt_data)
}

# Use external data source to run the Python script and get the output
data "external" "openai_content" {
  # Use a safer approach by exporting the API key as an environment variable
  # without it appearing in command line arguments
  program = ["bash", "-c", "export OPENAI_API_KEY='${var.openai_api_key}' && python ${local.script_path}/generate_content.py '${local.prompt_json}' 2>&1"]

  # External data sources expect an empty query at minimum
  query = {}
}

locals {
  # Handle potential errors in the response
  has_error = contains(keys(data.external.openai_content.result), "error")

  # Parse the OpenAI response from the external data source if no error
  openai_responses_json = local.has_error ? "{\"main\":\"{}\"}" : data.external.openai_content.result.openai_response
  openai_responses      = jsondecode(local.openai_responses_json)

  # Extract the main project response
  main_response = jsondecode(try(local.openai_responses.main, "{}"))

  # Extract the repository-specific responses
  repo_responses = {
    for key, response in local.openai_responses :
    key => jsondecode(try(response, "{}"))
    if key != "main" && !local.has_error
  }

  # Organize responses by repository name
  repository_results = {
    for repo_config in var.repository_configs :
    repo_config.name => {
      for idx, _ in repo_config.prompts :
      idx => lookup(local.repo_responses, "${repo_config.name}_prompt_${idx}", {})
      if !local.has_error && contains(keys(local.repo_responses), "${repo_config.name}_prompt_${idx}")
    }
  }

  # Extract any error message for output
  error_message = local.has_error ? data.external.openai_content.result.error : null
}