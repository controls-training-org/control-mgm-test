resource "aws_instance" "app_server" {
  ami           = "ami-08f9a9c699d2ab3f9"
  instance_type = var.instance_type

  tags = {
    Name = "ExampleAppServerInstance"
  }
}
