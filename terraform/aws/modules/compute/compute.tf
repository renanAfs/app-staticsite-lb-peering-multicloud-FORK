resource "aws_security_group" "sg_elb" {
  name        = "sg_elb"
  description = "sg_elb"
  vpc_id      = var.vpc10_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "sg_elb"
  }
}


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

resource "aws_lb" "ec2_lb" {
  name               = "ec2-elb"
  load_balancer_type = "application"
  subnets            = [var.sn_vpc10_pub1a, var.sn_vpc10_pub1b]
  security_groups    = [aws_security_group.sg_elb.id]
}

resource "aws_lb_target_group" "lb_tg" {
  name     = "lbtg"
  protocol = "HTTP"
  port     = 80
  vpc_id   = var.vpc10_id
}

resource "aws_lb_listener" "ec2_lb_listener" {
  protocol          = "HTTP"
  port              = 80
  load_balancer_arn = aws_lb.ec2_lb.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb_tg.arn
  }
}

data "template_file" "user_data" {
  template = file("./aws/modules/compute/scripts/userdata.sh")
}

resource "aws_instance" "ec2_public1a" {
    ami                    = var.ec2_ami
    instance_type          = "t2.micro"
    subnet_id              = aws_subnet.sn_vpc10_pub1a.id
    vpc_security_group_ids = [aws_security_group.sg_public.id]
    key_name               = "vockey"
    user_data              = base64encode(data.template_file.user_data.rendered)
}

resource "aws_instance" "ec2_public1b" {
    ami                    = var.ec2_ami
    instance_type          = "t2.micro"
    subnet_id              = aws_subnet.sn_vpc10_pub1b.id
    vpc_security_group_ids = [aws_security_group.sg_public.id]
    key_name               = "vockey"
    user_data              = base64encode(data.template_file.user_data.rendered)
}

resource "aws_instance" "ec2_private" {
    ami                    = var.ec2_ami
    instance_type          = "t2.micro"
    subnet_id              = aws_subnet.sn_vpc20_priv.id
    vpc_security_group_ids = [aws_security_group.sg_private.id]
    key_name               = "vockey"
    user_data              = base64encode(data.template_file.user_data.rendered)
}