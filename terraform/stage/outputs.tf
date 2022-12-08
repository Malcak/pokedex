output "load_balancer_ip" {
  value = aws_lb.default.dns_name
}

output "scraper_ip" {
  value = aws_instance.scraper.public_ip
}
