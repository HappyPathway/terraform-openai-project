#!/usr/bin/env python3
import os
import json
import sys
import traceback

try:
    from openai import OpenAI
except ImportError:
    print(json.dumps({"error": "OpenAI module not installed. Run 'pip install openai' to install it."}))
    sys.exit(1)

# Better error handling and debugging
try:
    # Parse input arguments
    if len(sys.argv) <= 1:
        print(json.dumps({"error": "No input arguments provided. Expected JSON input."}))
        sys.exit(1)
    
    input_data = json.loads(sys.argv[1])
    project_prompt = input_data.get('project_prompt')
    project_name = input_data.get('project_name')
    repo_org = input_data.get('repo_org')
    tags = input_data.get('tags', [])
    repository_configs = input_data.get('repository_configs', [])
    
    # Validate required inputs
    if not project_prompt:
        print(json.dumps({"error": "project_prompt is required but was not provided"}))
        sys.exit(0)  # Changed from sys.exit(1) to avoid Terraform external data source error
    if not project_name:
        print(json.dumps({"error": "project_name is required but was not provided"}))
        sys.exit(0)  # Changed from sys.exit(1) to avoid Terraform external data source error
    if not repo_org:
        print(json.dumps({"error": "repo_org is required but was not provided"}))
        sys.exit(0)  # Changed from sys.exit(1) to avoid Terraform external data source error
        
    # Set up OpenAI API client with the key from environment variable
    api_key = os.environ.get('OPENAI_API_KEY')
    if not api_key:
        print(json.dumps({"error": "OPENAI_API_KEY environment variable is not set"}))
        sys.exit(0)  # Changed from sys.exit(1) to avoid Terraform external data source error
        
    client = OpenAI(api_key=api_key)
    
    # Define the system message
    system_message = """
    You are an AI assistant specialized in generating repository content based on project prompts and tags.
    Generate appropriate content that matches the project requirements and context.
    """
    
    results = {}
    
    # Process the main project prompt first
    messages = [
        {"role": "system", "content": system_message},
        {"role": "user", "content": f"""
    Generate content for a repository with the following details:
    - Project Name: {project_name}
    - Organization: {repo_org}
    - Project Description: {project_prompt}
    - Tags: {', '.join(tags)}

    Please provide content in JSON format with the following structure:
    {{
      "readme_content": "# Full README.md content here",
      "best_practices": [
        "list of best practices for coding with ${{tags}}"
      ],
      "suggested_extensions": [
        "list of VS Code Extensions that would be useful for this project"
      ],
      "documentation_source": [
        "List of sources for documentation. should be github repositories that can be cloned into workspace"
      ]
      "copilor_insructions": "copilot-instructions file content"
    }}
    """
        }
    ]
    
    try:
        # Make API call to OpenAI for the main project - updated for latest OpenAI API
        response = client.chat.completions.create(
            model="gpt-4",
            messages=messages,
            # max_tokens=2000,
            temperature=0.9
        )
        
        # Extract the content from the response
        main_output = response.choices[0].message.content
        results["main"] = main_output
        
        # Process each repository configuration
        for repo_config in repository_configs:
            repo_name = repo_config.get('name')
            repo_tags = repo_config.get('tags', [])
            repo_prompts = repo_config.get('prompts', [])
            
            # Process each prompt for this repository
            for prompt_index, repo_prompt in enumerate(repo_prompts):
                prompt_key = f"{repo_name}_prompt_{prompt_index}"
                
                # Create messages for this repository prompt
                repo_messages = [
                    {"role": "system", "content": system_message},
                    {"role": "user", "content": f"""
                Generate content for a repository with the following details:
                - Project Name: {project_name}
                - Repository Name: {repo_name}
                - Organization: {repo_org}
                - Project Description: {project_prompt}
                - Repository Specific Description: {repo_prompt}
                - Project Tags: {', '.join(tags)}
                - Repository Tags: {', '.join(repo_tags)}

                Please provide content in JSON format with the following structure:
                {{
                  "readme_content": "# Full README.md content here",
                  "best_practices": [
                    "list of best practices for coding with ${{tags}}"
                  ],
                  "suggested_extensions": [
                    "list of VS Code Extensions that would be useful for this project"
                  ],
                  "documentation_source": [
                    "List of sources for documentation. should be github repositories that can be cloned into workspace"
                  ]
                }}
                """
                    }
                ]
                
                # Make API call to OpenAI for this repository prompt - updated for latest OpenAI API
                repo_response = client.chat.completions.create(
                    model="gpt-4",
                    messages=repo_messages,
                    max_tokens=2000,
                    temperature=0.7
                )
                
                # Extract the content from the response
                repo_output = repo_response.choices[0].message.content
                results[prompt_key] = repo_output
        
        # For Terraform external data source, we need to print valid JSON to stdout
        print(json.dumps({"openai_response": json.dumps(results)}))
        
    except Exception as e:
        error_message = f"Error calling OpenAI API: {str(e)}"
        print(json.dumps({"error": error_message}))
        sys.exit(0)  # Changed from sys.exit(1) to avoid Terraform external data source error
        
except json.JSONDecodeError as je:
    print(json.dumps({"error": f"Invalid JSON input: {str(je)}"}))
    sys.exit(0)  # Changed from sys.exit(1) to avoid Terraform external data source error
except Exception as e:
    error_traceback = traceback.format_exc()
    print(json.dumps({"error": f"Unexpected error: {str(e)}\n{error_traceback}"}))
    sys.exit(0)  # Changed from sys.exit(1) to avoid Terraform external data source error