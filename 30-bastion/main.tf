resource "aws_instance" "Bastion" {
  ami           = local.ami_id
  instance_type = "t3.micro"
  
  subnet_id              = local.public_subnet_id
  associate_public_ip_address = true
  vpc_security_group_ids = [local.bastion_sg_id] 
  iam_instance_profile = aws_iam_instance_profile.bastion.name



 user_data = templatefile("${path.module}/bastion.sh.tftpl",{
   partition_number = 4
    extend_size = 30
      })


  #By  default we only get 20gb now we get as 50gb,by adding 30gb growpart  for bastion is sufficient to run that y weuse root block
   root_block_device {
    volume_type           = "gp3"
    volume_size           = 50 
    delete_on_termination = true

     tags = merge(
      {
     Name =  "${local.common_name}-Bastion"
      },
      local.common_tags
     )
   }
  
   tags = merge(
    {
    Name = "${local.common_name}-bastion"
    },
     local.common_tags
  )
   }