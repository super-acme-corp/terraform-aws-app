data "aws_route53_zone" "default" {
    zone_id = var.dns_zone_id
}

resource "aws_route53_record" "app_ipv4" {
    zone_id = data.aws_route53_zone.default.zone_id 
    name = var.lb_subdomain
    type = "A"

    alias {
        name = aws_lb.app_lb.dns_name
        zone_id = aws_lb.app_lb.zone_id
        evaluate_target_health = false
    }
}

data "aws_acm_certificate" "app_cert" {
    domain = "*.${data.aws_route53_zone.default.name}" 
}