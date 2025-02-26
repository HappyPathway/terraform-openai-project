variable "project_prompt" {
  description = "High-level description of project purpose"
  type        = string
}

variable "repo_org" {
  description = "GitHub organization name"
  type        = string
}

variable "project_name" {
  description = "Base name for project repositories"
  type        = string
}

variable "tags" {
  description = "List of tags to associate with the prompt"
  type        = list(string)
  default     = []
}

variable "openai_api_key" {
  description = "OpenAI API key for authentication"
  type        = string
  sensitive   = true
}

variable "model" {
  description = "OpenAI model to use for prompt generation"
  type        = string
  default     = "gpt-4"
}

variable "repository_configs" {
  description = "List of repository configurations with tags and prompts"
  type = list(object({
    name    = string
    tags    = list(string)
    prompts = list(string)
  }))
  default = []
}