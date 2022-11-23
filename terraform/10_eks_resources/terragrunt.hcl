include "global_config" {
  path = find_in_parent_folders("terragrunt-global-config.hcl")
}

dependency "05_eks_cluster" {
  config_path  = "../05_eks_cluster"
  skip_outputs = true
}
