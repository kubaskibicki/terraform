provider "aws" {
	region = "us-east-1"
}


module "webserver_cluster" {
    source = "../../modules/services/webserver-cluster"
}

resource "aws_launch_template" "launchtemplate" {
	image_id = "ami-002e81a9a522f1f19"
	instance_type = "t2.micro"
    vpc_security_group_ids = [aws_security_group.allow_all.id]

    user_data = base64encode(templatefile("user-data.sh", {
        server_port = var.server_port
        db_address = data.terraform_remote_state.db.outputs.address
        db_port = data.terraform_remote_state.db.outputs.port
    }))
}


resource "aws_autoscaling_group" "example" {
    min_size = 2
    max_size = 10

    launch_template {
        id = aws_launch_template.launchtemplate.id
        version = "$Latest"
    }
    vpc_zone_identifier  = data.aws_subnets.default.ids

    target_group_arns = [aws_lb_target_group.target_group.arn]
    health_check_type = "ELB"

    tag {
        key = "Name"
        value = "terraform-asg-example"
        propagate_at_launch = true
    }
}

resource "aws_security_group" "allow_all" {
    name = "123"

    ingress {
        from_port   = var.server_port
        to_port     = var.server_port
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_lb" "load_balancer" {
    load_balancer_type = "application"
    subnets = data.aws_subnets.default.ids
    security_groups = [aws_security_group.alb.id]
}

resource "aws_lb_listener" "listener" {
    load_balancer_arn = aws_lb.load_balancer.arn
    port = 80
    protocol = "HTTP"

    default_action {
        type = "fixed-response"

        fixed_response {
            content_type = "text/plain"
            message_body = "404: page not found"
            status_code = 404
        }
    }
}

resource "aws_lb_target_group" "target_group" {

    name = "terraform-asg-example"

    port     = var.server_port
    protocol = "HTTP"
    vpc_id   = data.aws_vpc.default.id

    health_check {
        path                = "/"
        protocol            = "HTTP"
        matcher             = "200"
        interval            = 15
        timeout             = 3
        healthy_threshold   = 2
        unhealthy_threshold = 2
    }
}

resource "aws_security_group" "alb" {

  name = "terraform-example-alb"

  # Allow inbound HTTP requests
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound requests
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb_listener_rule" "asg" {
    listener_arn = aws_lb_listener.listener.arn
    priority     = 100

    condition {
        path_pattern {
            values = ["*"]
        }
    }

    action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.target_group.arn
    }
}

data "aws_vpc" "default" {
    default = true
}

data "aws_subnets" "default" {
    filter {
        name   = "vpc-id"
        values = [data.aws_vpc.default.id]
    }
}

data "terraform_remote_state" "db" {
    backend = "s3"

    config = {
        bucket = var.bucket_name
        key = var.db_remote_state_key
        region = "us-east-1"
    }
}