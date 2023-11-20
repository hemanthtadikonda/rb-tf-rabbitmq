resource "aws_security_group" "main" {
  name        = "${local.name_prefix}-sg"
  description = "${local.name_prefix}-sg"
  vpc_id      = var.vpc_id
  tags = merge(local.tags , {Name = "${local.name_prefix}-sg" })

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = var.ssh_ingress_cidr
  }
  ingress {
    description      = "RABBITMQ"
    from_port        = 5672
    to_port          = 5672
    protocol         = "tcp"
    cidr_blocks      = var.sg_ingress_cidr
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_instance" "main" {
  ami           = data.aws_ami.ami.id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id[0]
  vpc_security_group_ids = [ aws_security_group.main.id]
  user_data     = file("${path.module}/userdata.sh")
  tags = merge(local.tags , {Name = "${local.name_prefix}-inst-${count.index + 1}" })

}

resource "aws_route53_record" "www" {
  zone_id = var.zone_id
  name    = local.name_prefix
  type    = "A"
  ttl     = 30
  records = [aws_instance.main.private_ip]
}
