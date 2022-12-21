resource "aws_ecs_cluster" "Travelly" {
    name = var.ecs_cluster_name #"travelly"
}

resource "aws_ecs_task_definition" "task_definition" {
    network_mode = "awsvpc"
    family                = var.task_definition_name #"travelly_task"
    /*container_definitions = jsonencode([{
      name = "hello"
      image = "8072388539/ttravel:latest"
      essential = true
      environment = [
        {"name":"hello","DB_URL": "${local.link}","DB_PORT": 3306,"USERNAME":"${aws_db_instance.rds_database.username}","PASSWORD":"${var.database_password}","DB_NAME":"${aws_db_instance.rds_database.name}"}
      ]
      portMappings = [{
        protocol = "tcp"
        containerPort = 8080
        hostPort = 8080
      }]
    }])
      #file("taskservice.json") file("task-definitions/taskservice.json")*/
      container_definitions = <<EOF
[
    {
      "name": "hello",
      "image": "8072388539/ttravel:latest",
      "essential": true,
      "portMappings": [
        {
          "protocol": "tcp",
          "containerPort": 8080,
          "hostPort": 8080
        }
      ],
      "environment": [
        {
          "name": "DB_URL",
          "value": "${local.link}"
        },
        {
          "name": "DB_PORT",
          "value": "3306"
        },
        {
          "name": "USERNAME",
          "value": "${aws_db_instance.rds_database.username}"
        },
        {
          "name": "PASSWORD",
          "value": "${var.database_password}"
        },
        {
          "name": "DB_NAME",
          "value": "${aws_db_instance.rds_database.name}"
        }
      ]
      
    }
]
EOF
    requires_compatibilities = [ "FARGATE" ]
    cpu = 256
    memory = 512
    execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
    task_role_arn = aws_iam_role.ecs_task_role.arn
}

resource "aws_ecs_service" "travelly" {
  name            = var.ecs_service_name #"travelly"
  cluster         = aws_ecs_cluster.Travelly.id
  task_definition = aws_ecs_task_definition.task_definition.arn
  desired_count   = 3
  /*iam_role        = aws_iam_role.foo.arn
  depends_on      = [aws_iam_role_policy.foo]*/
  launch_type = "FARGATE"
  network_configuration {
    security_groups = [aws_security_group.vpc_securitygroup.id] #["sg-01e542f742213da19"]    #"sg-01e542f742213da19"
    subnets = aws_subnet.ECS_vpc_subnet.*.id
    assign_public_ip = true
  }
  load_balancer {
    	target_group_arn  = aws_alb_target_group.app.id
    	container_port    = 8080
    	container_name    = "hello"
	}
  depends_on = [ aws_alb_listener.front_end ]
}