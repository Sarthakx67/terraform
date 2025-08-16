resource "aws_instance" "master_node" {
  ami           = data.aws_ami.roboshop-ami.id
  instance_type = "t2.micro"    
  key_name = "EC2-key"
  vpc_security_group_ids = [aws_security_group.allow_master.id]
  user_data = filebase64("master-node.sh")
  root_block_device {
  volume_size = 10 # 10 gb
  }
  tags = {
    Name = "master_node"
  }
}
resource "aws_instance" "slave_node" {
  for_each = var.slave_nodes
  ami           = data.aws_ami.roboshop-ami.id
  instance_type = each.value
  key_name = "EC2-key"
  vpc_security_group_ids = [aws_security_group.allow_master.id]
  user_data = filebase64("slave-node.sh")
  root_block_device {
  volume_size = 10 # 10 gb
  }
  tags = {
    Name = each.key
  }
}