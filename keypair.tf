# Define SSH key pair for our instances
resource "aws_key_pair" "devops" {
  key_name = "ec2_key_pair"
  public_key = "${file("${var.key_path}")}"
}