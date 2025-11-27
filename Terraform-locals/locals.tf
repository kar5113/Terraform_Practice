locals{
    instance-type="t3.micro"
    project="Instana"
    Application="Roboshop-${var.environment}"
    common_name="${var.project}-${var.application}-${var.environment}"
    ami_id=data.aws_ami.ami
}

variable "environment" {
  type=string
  default="dev"
}
variable "project" {
  type=string
  default="Instana"
}
variable "application" {
    type=string
  default="Roboshop"
}