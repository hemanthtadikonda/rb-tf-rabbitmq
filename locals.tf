locals {
  name_prefix = "${var.env}-rabbitmq"
  tags        = merge( var.tags,{ tf-module = "rabbitmq" },{ env = var.env })
}
