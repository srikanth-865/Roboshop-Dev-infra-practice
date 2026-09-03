resource "aws_instance" "vpn" {
  ami           = local.ami_id
  instance_type = "t3.micro"
  subnet_id              = local.public_subnet_id
  associate_public_ip_address = true
  vpc_security_group_ids = [local.vpn_sg_id] 
 
 user_data = file("vpn.sh")

  
   tags = merge(
    {
    Name = "${local.common_name}-vpn"
    },
     local.common_tags
  )
   }