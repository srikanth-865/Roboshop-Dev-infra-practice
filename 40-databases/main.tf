resource "aws_instance" "mongodb" {
  ami           = local.ami_id
  instance_type = "t3.micro"
  subnet_id     = local.database_subnet_id
  vpc_security_group_ids      = [local.mongodb_sg_id]
  associate_public_ip_address = false

  tags = merge(
    local.common_tags,
    {
        Name = "${local.common_name}-mongodb"
    }
  )
}

resource "terraform_data" "mongodb" {
  # Re-run if the instance ID or IP changes
  triggers_replace = {
    instance_id = aws_instance.mongodb
    instance_ip = aws_instance.web.private_ip
  }
  
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = "DevOps321"
    host        = aws_instance.mongodb.id
  }

# 2. Copy a single local file to a remote destination
  provisioner "file" {
    source      = "script.sh"
    destination = "/tmp/script.sh"
  }
  provisioner "remote-exec" {
    command = [
       "chmod +x /tmp/script.sh"
       "sudo /tmp/script.sh mongodb ${var.environment} roboshop.yaml"
    
    ]
  }
}
 