resource "aws_instance" "catalogue" {
  instance_type = "t3.micro"
  ami = local.ami_id
  subnet_id     = local.private_subnet_id[0]
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
       "sudo /tmp/script.sh catalogue ${var.environment} ${var.app_version} "
    ]
}
}
resource "aws_ec2_instance_state" "catalogue" {   
  instance_id = aws_instance.catalogue.id
  state       = "stopped"
  depends_on = [terraform_data.catalogue]   #its for stopping the instance after completing of terraform data
}

resource "aws_ami_from_instance" "catalogue" {  #creating ami for catalogue instance
  name               ="${local.common_name}-catalogue-${var.app_version}-${aws_instance.catalogue.id}"  #Roboshop1-Dev-catalogue-v3-id..
  source_instance_id = aws_instance.catalogue.id
  depends_on = [aws_ec2_instance_state.catalogue]   #its for after stopping the instance state then it will run this ami creation resource

   tags = merge(
    local.common_tags,
    {
        Name = "${local.common_name}-Catalogue-${var.app_version}-${aws_instance.catalogue.id}"
    }
  )

}

#creating launch template 

resource "aws_launch_template" "catalogue" {
  name = "${local.common_name}-catalogue"
  image_id = aws_ami_from_instance.catalogue.id  #AMI ID
  instance_initiated_shutdown_behavior = "terminate"
  vpc_security_group_ids = [local.catalogue_sg_id]
  update_default_version = true

#Once the instances are created this will become instance tags
  tag_specifications {
    resource_type = "instance"

    tags =  merge(
    local.common_tags,
    {
        Name = "${local.common_name}-Catalogue-${var.app_version}-${aws_instance.catalogue.id}"
    }
  )
  }

#Once the instances are created this will become volume tags
   tag_specifications {
    resource_type = "volume"

    tags =  merge(
    local.common_tags,
    {
        Name = "${local.common_name}-Catalogue-${var.app_version}-${aws_instance.catalogue.id}"
    }
  )
  }

 #this for launch template resource tags
 tags =  merge(
    local.common_tags,
    {
        Name = "${local.common_name}-Catalogue-${var.app_version}-${aws_instance.catalogue.id}"
    }
  )
}

resource "aws_lb_target_group" "catalogue" {
  name     = "${local.common_name}"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = local.vpc_id

   # Time in seconds for releasing instances in the target group 
  deregistration_delay = 30 #seconds

    health_check {
    enabled             = true
    path                = "/health"
    protocol            = "HTTP"
    port                = 8080
    interval            = 10
    timeout             = 5 #secs
    healthy_threshold   = 2
    unhealthy_threshold = 2 
    matcher             = "200-299" #status success
  }
}




  