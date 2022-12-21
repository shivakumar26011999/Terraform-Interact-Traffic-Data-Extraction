locals{
    lambda_zip_location = "outputs/lambda.zip"
    link = element(split(":", aws_db_instance.rds_database.endpoint),0)
}
data "archive_file" "init" {
    type        = "zip"
    source_file = "lambda.py"
    output_path = local.lambda_zip_location
}

resource "aws_lambda_function" "test_lambda" {
    filename      = local.lambda_zip_location
    function_name = var.lambda_function_name
    role          = aws_iam_role.lambda_role.arn
    handler       = "lambda.lambda_handler"
    runtime = "python3.7"
    layers = ["arn:aws:lambda:ap-south-1:211475862740:layer:pymysqlayer:1"]
    environment {
        variables = {
          rdslink = element(split(":", aws_db_instance.rds_database.endpoint),0)
          uname = aws_db_instance.rds_database.username
          psd = "shivakumar"
          databasename = aws_db_instance.rds_database.name
          firstbucket = aws_s3_bucket.camera_uploads_bucket.id
          secondbucket = aws_s3_bucket.after_lambda.id
        }
    }
}

resource "aws_lambda_permission" "allow_s3_bucket" {
    statement_id = "AllowExecutionFromS3Bucket"
    action = "lambda:InvokeFunction"
    function_name = aws_lambda_function.test_lambda.arn 
    principal = "s3.amazonaws.com"
    source_arn = aws_s3_bucket.camera_uploads_bucket.arn
}

resource "aws_lambda_permission" "allow_s3_second_bucket" {
    statement_id = "AllowExecutionFromS3Bucketdifferent"
    action = "lambda:InvokeFunction"
    function_name = aws_lambda_function.test_lambda.arn 
    principal = "s3.amazonaws.com"
    source_arn = aws_s3_bucket.after_lambda.arn
}

