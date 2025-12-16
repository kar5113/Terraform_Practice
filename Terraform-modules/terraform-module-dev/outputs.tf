
# providing outputs from the module , can be used by the module caller
output "public_ip"{
    value= aws_instance.this.public_ip
    description= "The public IP address of the EC2 instance"
    sensitive = false
    depends_on = [ aws_instance.this ]
}

output "private_ip"{
    value= aws_instance.this.private_ip
    description= "The private IP address of the EC2 instance"
    sensitive = false
    depends_on = [ aws_instance.this ]
}