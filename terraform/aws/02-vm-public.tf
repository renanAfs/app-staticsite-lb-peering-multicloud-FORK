resource "aws_security_group" "sg_public" {
    name   = "sg_public"
    vpc_id = aws_vpc.vpc10.id
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
        cidr_blocks = ["10.0.0.0/16", "20.0.0.0/16"]
    }
    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_instance" "ec2_public" {
    ami                    = "ami-0f409bae3775dc8e5"
    instance_type          = "t2.micro"
    subnet_id              = aws_subnet.sn_vpc10_pub.id
    vpc_security_group_ids = [aws_security_group.sg_public.id]
    key_name               = "vockey"
}