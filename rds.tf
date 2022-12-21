resource "aws_db_instance" "rds_database" {
    allocated_storage    =  20
    storage_type         =  "gp2"
    engine               =  "mysql"
    engine_version       =  "5.7"
    instance_class       =  "db.t2.micro"
    name                 =  var.database_name #"mydb"
    username             =  var.database_username #"root"
    password             =  var.database_password #"shivakumar"
    parameter_group_name =  "default.mysql5.7"
    publicly_accessible  =  true
    skip_final_snapshot  =  true
}