resource "aws_s3_bucket" "camera_uploads_bucket" {
    bucket = var.first_bucket_name #"created-to-upload-images"

    tags = {
      "Name" = "first_bucket"
    }
}

resource "aws_s3_bucket_notification" "bucket_notification_to_lambda"{
    bucket = aws_s3_bucket.camera_uploads_bucket.id

    lambda_function {
      lambda_function_arn = aws_lambda_function.test_lambda.arn
      events = ["s3:ObjectCreated:*"]
    }

    depends_on = [aws_lambda_permission.allow_s3_bucket]
}

resource "aws_s3_bucket" "after_lambda" {
  bucket = var.second_bucket_name #"after-triggering-lambda"

  tags = {
    "Name" = "second_bucket"
  }
}

resource "aws_s3_bucket_notification" "second_bucket_notification_to_lambda"{
  bucket = aws_s3_bucket.after_lambda.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.test_lambda.arn 
    events = ["s3:ObjectCreated:*"]
  }
  depends_on = [aws_lambda_permission.allow_s3_second_bucket]
}
