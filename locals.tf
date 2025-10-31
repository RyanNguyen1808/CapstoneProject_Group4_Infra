locals {
  # sanitize workspace name: convert to lowercase
  workspace_safe = lower(terraform.workspace)
}