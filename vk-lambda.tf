data "archive_file" "python_package" {
  type        = "zip"
  source_file = "./python/lambda_function.py"
  output_path = "python.zip"
}

resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.image_processor.arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.vk_bucket_a.arn
}

resource "aws_lambda_function" "image_processor" {
  function_name    = "imageProcessor"
  filename         = "python.zip"
  source_code_hash = data.archive_file.python_package.output_base64sha256
  role             = aws_iam_role.lambda_role.arn
  runtime          = "python3.9"
  handler          = "lambda_function.handler"
  timeout          = 10
  layers           = ["arn:aws:lambda:eu-west-2:770693421928:layer:Klayers-p39-pillow:1"]
}