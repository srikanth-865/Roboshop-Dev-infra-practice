resource "aws_instance" "mongodb" {
  ami           = local.ami_id
  instance_type = "t3.micro"
  subnet_id     = local.database_subnet_id
  vpc_security_group_ids      = [local.mongodb_sg_id]

  tags = merge(
    local.common_tags,
    {
        Name = "${local.common_name}-mongodb"
    }
  )
}

resource "terraform_data" "mongodb" {
  # Re-run if the instance ID or IP changes
  triggers_replace =  [
    aws_instance.mongodb.id,
  ]
  
  connection {
    type        = "ssh"
    user        = "ec2-user"
    password = "DevOps321"
    host        = aws_instance.mongodb.private_ip
  }

# 2. Copy a single local file to a remote destination
  provisioner "file" {
    source      = "script.sh"
    destination = "/tmp/script.sh"
  }
  provisioner "remote-exec" {
    inline = [
       "chmod +x /tmp/script.sh",
       "sudo  sh /tmp/script.sh mongodb ${var.environment}"
    
    ]
  }
}
 
 resource "aws_instance" "redis" {
  ami           = local.ami_id
  instance_type = "t3.micro"
  subnet_id     = local.database_subnet_id
  vpc_security_group_ids      = [local.redis_sg_id]

  tags = merge(
    local.common_tags,
    {
        Name = "${local.common_name}-redis"
    }
  )
}

resource "terraform_data" "redis" {
  # Re-run if the instance ID or IP changes
  triggers_replace =  [
    aws_instance.redis.id,
  ]
  
  connection {
    type        = "ssh"
    user        = "ec2-user"
    password = "DevOps321"
    host        = aws_instance.redis.private_ip
  }

# 2. Copy a single local file to a remote destination
  provisioner "file" {
    source      = "script.sh"
    destination = "/tmp/script.sh"
  }
  provisioner "remote-exec" {
    inline = [
       "chmod +x /tmp/script.sh",
       "sudo  sh /tmp/script.sh redis ${var.environment}"
    
    ]
  }
}
 
 ##rabbitmq
 resource "aws_instance" "rabbitmq" {
  ami           = local.ami_id
  instance_type = "t3.micro"
  subnet_id     = local.database_subnet_id
  vpc_security_group_ids      = [local.rabbitmq_sg_id]

  tags = merge(
    local.common_tags,
    {
        Name = "${local.common_name}-rabbitmq"
    }
  )
}

resource "terraform_data" "rabbitmq" {
  # Re-run if the instance ID or IP changes
  triggers_replace =  [
    aws_instance.rabbitmq.id,
  ]
  
  connection {
    type        = "ssh"
    user        = "ec2-user"
    password = "DevOps321"
    host        = aws_instance.rabbitmq.private_ip
  }

# 2. Copy a single local file to a remote destination
  provisioner "file" {
    source      = "script.sh"
    destination = "/tmp/script.sh"
  }
  provisioner "remote-exec" {
    inline = [
       "chmod +x /tmp/script.sh",
       "sudo  sh /tmp/script.sh rabbitmq ${var.environment}"
    
    ]
  }
}
 
##mysql
 resource "aws_instance" "mysql" {
  ami           = local.ami_id
  instance_type = "t3.micro"
  subnet_id     = local.database_subnet_id
  vpc_security_group_ids      = [local.mysql_sg_id]
  iam_instance_profile = aws_iam_instance_profile.mysql.name

  tags = merge(
    local.common_tags,
    {
        Name = "${local.common_name}-mysql"
    }
  )
}

resource "terraform_data" "mysql" {
  # Re-run if the instance ID or IP changes
  triggers_replace =  [
    aws_instance.mysql.id,
  ]
  
  connection {
    type        = "ssh"
    user        = "ec2-user"
    password = "DevOps321"
    host        = aws_instance.mysql.private_ip
  }

# 2. Copy a single local file to a remote destination
  provisioner "file" {
    source      = "script.sh"
    destination = "/tmp/script.sh"
  }
  provisioner "remote-exec" {
    inline = [
       "chmod +x /tmp/script.sh",
       "sudo  sh /tmp/script.sh mysql ${var.environment}"
    
    ]
  }
}
 