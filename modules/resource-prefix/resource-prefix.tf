locals {
  owner_short = substr(var.owner, 0, 1)
  env_short = substr(var.env, 0, 1)
  resource_prefix = "${local.owner_short}${local.env_short}-${var.project}"
}
