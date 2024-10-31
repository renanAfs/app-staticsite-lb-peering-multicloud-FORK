resource "aws_security_group" "sg_private" {
    name   = "sg_private"
    vpc_id = aws_vpc.vpc20.id
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["20.0.0.0/16", "10.0.0.0/16"]
    }
}

resource "aws_instance" "ec2_private" {
    ami                    = "ami-0f409bae3775dc8e5"
    instance_type          = "t2.micro"
    subnet_id              = aws_subnet.sn_vpc20_priv.id
    vpc_security_group_ids = [aws_security_group.sg_private.id]
    key_name               = "vockey"
}