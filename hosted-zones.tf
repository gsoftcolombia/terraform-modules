# Addional NS records in gsoftcolombia.co might be required to delegate the s.gsoftcolombia.co subdomain to this hosted zone.
resource "aws_route53_zone" "sandbox" {
  name = "s.gsoftcolombia.co"
}