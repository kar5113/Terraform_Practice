resource "aws_instance" "example" {
  ami           = local.ami_id
  instance_type = "t3.micro"
  subnet_id = local.public_subnet_ids[0]
  vpc_security_group_ids = [local.bastion_sg_id]  
  root_block_device {
    volume = 50
  }
# Install terraform, ansible , git here
user_data = <<-EOF
              #!/bin/bash
              growpart /dev/nvme0n1 4
              lvextend -L +30G /dev/mapper/RootVG-varVol
              xfs_growfs /var
              sudo yum install -y yum-utils
              sudo yum install -y terraform
              sudo yum install -y git
              sudo yum install -y ansible
          EOF

  tags = merge(
        local.common_tags,{
            Name= "${local.common_name_suffix}-bastion"
        }
    )
}
