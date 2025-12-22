local{
    frontend-alb-sg-id=data.aws_ssm_parameter.frontend_alb_sg_id.value
    
    frontend-sg-id=data.aws_ssm_parameter.frontend-sg-id.value

    mongodb-sg-id=data.aws_ssm_parameter.mongodb-sg-id.value

    bastion-sg-id=data.aws_ssm_parameter.bastion-sg-id.value
}