resource "aws_instance" "catalogue" {
  instance_type = "t3.micro"
  subnet_id     = local.private_subnet_id
  vpc_security_group_ids = [local.catalogue_sg_id]


  tags = merge(
    local.common_tags,
    {
        Name = "${local.common_name}-Catalogue"
    }
  )
}

resource "terraform_data" "catalogue" {
  # Triggers a recreation whenever the  script version changes
  triggers_replace = [
    aws_instance.catalogue.id,
  ]

   connection {
    type        = "ssh"
    user        = "ec2-user"
    password    = "DevOps321"
    host        = aws_instance.catalogue.private_ip
  }

  # 2. Use the file provisioner to copy the local file
  provisioner "file" {
    source      = "script.sh"      # Path on your local machine
    destination = "/tmp/script.sh"  # Path on the remote instance
  }

provisioner "remote-exec" {
    inline = [
        "chmod +x /tmp/script.sh",
       "sudo /tmp/script.sh catalogue ${var.environment} "
    ]
}
}


  