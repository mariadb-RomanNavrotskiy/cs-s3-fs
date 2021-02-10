data "aws_route53_zone" "zone" {
  name         = var.zone.name
  private_zone = false
}

resource "aws_route53_record" "record" {
  count   = var.instance.count
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = "${var.zone.prefix}${count.index + 1}.${data.aws_route53_zone.zone.name}"
  type    = "A"
  ttl     = "300"
  records = [element(aws_eip.eip.*.public_ip, count.index)]
}
