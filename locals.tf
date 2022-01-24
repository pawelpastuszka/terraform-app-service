locals {
  resource_prefix = "${substr(var.owner, 0, 1)}${substr(terraform.workspace, 0, 1)}-${var.project}"

  tags = {
    "Owner"       = var.owner,
    "Environment" = var.env,
    "Project"     = var.project,
    "Management"  = "terraform",
  }
}
