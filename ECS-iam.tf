/*resource "aws_iam_role_policy" "ECS_policy" {
    name = "ECS-policy"
    role = aws_iam_role.ecs_task_role.id
    policy = file("iam/ECS_role.json")
}
resource "aws_iam_role" "ecs_task_role" {
    name = "ecs_task_role"
    assume_role_policy = file("iam/ECS_assume_role_policy.json")
}*/

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecs-role"
 
  assume_role_policy = file("iam/ECS_assume_role_policy.json")
}

resource "aws_iam_role" "ecs_task_role" {
  name = "role-name-task"
 
  assume_role_policy = file("iam/ECS_assume_role_policy.json")
}

resource "aws_iam_role_policy_attachment" "ecs-task-execution-role-policy-attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchFullAccess"
}

resource "aws_iam_role_policy_attachment" "task_rds" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonRDSFullAccess"
}

