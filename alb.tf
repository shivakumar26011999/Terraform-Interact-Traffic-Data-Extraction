resource "aws_alb" "main" {
    name = "myapp-load-balancer"
    subnets = aws_subnet.ECS_vpc_subnet.*.id
    security_groups = [ aws_security_group.vpc_securitygroup.id ]
}

resource "aws_alb_target_group" "app" {
    name = "myapp-target-group"
    port = 8080
    protocol = "HTTP"
    vpc_id = aws_vpc.ECS_vpc.id 
    target_type = "ip"
    health_check {
      healthy_threshold = "3"
      interval = "30"
      protocol = "HTTP"
      matcher = ""
      timeout = "10"
      path = "/home"
      unhealthy_threshold = "2"
    }
}
resource "aws_alb_listener" "front_end" {
    load_balancer_arn = aws_alb.main.id
    port = 80
    protocol = "HTTP"

    default_action {
        target_group_arn = aws_alb_target_group.app.id
        type = "forward"
    }
}