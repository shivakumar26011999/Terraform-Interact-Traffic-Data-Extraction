resource "aws_route53_zone" "main" {
  name = "trueweb.guru"
}
/*resource "aws_route53_zone" "dev" {
  name = "www.trueweb.guru"

  tags = {
    Environment = "dev"
  }
}*/
resource "aws_route53_record" "dev-ns" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "www"
  type    = "CNAME"
  ttl     = "30"
  records = [ "${aws_alb.main.dns_name}" ] 
}
