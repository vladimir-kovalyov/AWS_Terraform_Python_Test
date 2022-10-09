data "aws_iam_policy_document" "lambda_assume_role_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "lambda_role" {
  name               = "lambda-lambdaRole-waf"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy.json
}



resource "aws_iam_policy" "get_s3_object" {
  name        = "get-s3-object"
  description = "GetObject policy for Lambda from Bucket A"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "GetFile",
      "Action": [
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.vk_bucket_a.arn}/*"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "attach_allow_for_a" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.get_s3_object.arn
}



resource "aws_iam_policy" "upload_s3_object" {
  name        = "upload-s3-object"
  description = "uploadObject policy for Lambda to Bucket B"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "GetFile",
      "Action": [
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.vk_bucket_b.arn}/*"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "attach_allow_for_b" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.upload_s3_object.arn
}


resource "aws_iam_policy" "vk_lambda_execution_role" {
  name        = "vk-lambda-execution-role"
  description = "Allow logs"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "attach_execution_role_for_vk_lambda" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.vk_lambda_execution_role.arn
}