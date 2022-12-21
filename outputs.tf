output "rds_endpoint" {
    value = aws_db_instance.rds_database.endpoint
}
output "rds_id" {
    value = aws_db_instance.rds_database.id
}
output "rds_db_name" {
    value = aws_db_instance.rds_database.name
}
output "rds_db_username" {
    value = aws_db_instance.rds_database.username
}
output "alb" {
    value = aws_alb.main.dns_name
}