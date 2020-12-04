resource "aws_launch_configuration" "worker" {
    name_prefix = "Autoscaled-"
    image_id = var.ami
    instance_type = var.instance_type
    security_groups = [aws_security_group.ec2_public_security_group.id]
    associate_public_ip_address = true
    key_name = "pem_test"
    user_data = <<-EOF
                #!/bin/bash
                yum update -y
                yum install -y httpd
                systemctl start httpd.service
                systemctl enable httpd.service
                echo "Public Autoscaling E2 : $(hostname -f)" > /var/www/html/index.html
                EOF
    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_autoscaling_group" "worker" {
    name = "my_asg_${aws_launch_configuration.worker.name}"
    min_size = 2
    desired_capacity = 2
    max_size = 3
    vpc_zone_identifier = aws_subnet.public_subnets.*.id
    launch_configuration = aws_launch_configuration.worker.name
    health_check_type = "ELB"

    target_group_arns = [aws_alb_target_group.alb_front_http.arn]
    default_cooldown = 30
    health_check_grace_period = 30
    lifecycle {
            create_before_destroy = true
    }
}