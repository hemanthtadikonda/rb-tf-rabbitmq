locals {
  name_prefix = "rabbitmq-${var.env}"
  tags        = merge( var.tags,{ tf-module = "rabbitmq" },{ env = var.env })
}
