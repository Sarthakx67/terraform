resource "aws_instance" "my_choice_name" {
  ami           = "ami-00ca570c1b6d79f36"
  instance_type = var.instance_type
  key_name      = "EC2-key"

  vpc_security_group_ids = [
    aws_security_group.allow_all.id
  ]

  # user_data = filebase64("k3s-bootstrap.sh")

  root_block_device {
    volume_size           = 40
    volume_type           = "gp3"
    delete_on_termination = true
    encrypted             = true
  }

  instance_market_options {
    market_type = "spot"

    spot_options {
      spot_instance_type             = "one-time"
      instance_interruption_behavior = "terminate"
    }
  }

  tags = {
    Name = "spot-server"
  }
}
