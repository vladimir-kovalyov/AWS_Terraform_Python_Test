##############################################
###        BUCKET "A" CREATION        ########
############################################## 


resource "aws_s3_bucket" "vk_bucket_a" {
  bucket = "vk-bucket-a"

  tags = {
    Name = "Bucket A"
  }
}

resource "aws_s3_bucket_acl" "bucket_a_acl" {
  bucket = aws_s3_bucket.vk_bucket_a.id
  acl    = "private"
}


##############################################
###        BUCKET "B" CREATION        ########
############################################## 


resource "aws_s3_bucket" "vk_bucket_b" {
  bucket = "vk-bucket-b"

  tags = {
    Name = "Bucket B"
  }
}

resource "aws_s3_bucket_acl" "bucket_b_acl" {
  bucket = aws_s3_bucket.vk_bucket_b.id
  acl    = "private"
}


##############################################
###     TRIGGER LAMBDA FROM BUCKET A  ########
##############################################

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.vk_bucket_a.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.image_processor.arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_lambda_permission.allow_bucket]
}