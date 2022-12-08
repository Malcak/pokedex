# resource "tls_private_key" "private_key" {
#   algorithm = "RSA"
#   rsa_bits  = 4096
# }

# resource "aws_key_pair" "key_pair" {
#   key_name   = "${var.project}-${var.environment}-prometheus-key"
#   public_key = tls_private_key.private_key.public_key_openssh
# }

# resource "local_file" "save_key" {
#   content  = tls_private_key.private_key.private_key_pem
#   filename = "./prometheus-key.pem"
# }

data "aws_key_pair" "key_pair" {
  key_name = "${var.project}-${var.environment}-prometheus-key"
}
