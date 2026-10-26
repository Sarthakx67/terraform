resource "aws_instance" "master_node" {
  ami           = "ami-00ca570c1b6d79f36"
  instance_type = "t2.micro"    
  key_name = "EC2-key"
  vpc_security_group_ids = [aws_security_group.allow_master.id]
  user_data = filebase64("master-node.sh")
  root_block_device {
  volume_size = 20 # 10 gb
  }
  tags = {
    Name = "master_node"
  }
}
resource "aws_instance" "slave_node" {
  for_each = var.slave_nodes
  ami           = "ami-00ca570c1b6d79f36"
  instance_type = each.value
  key_name = "EC2-key"
  vpc_security_group_ids = [aws_security_group.allow_master.id]
  user_data = filebase64("slave-node.sh")
  root_block_device {
  volume_size = 20 # 10 gb
  }
  tags = {
    Name = each.key
  }
}