resource "aws_iam_user" "vk_user_a" {
  name = "user-a"
}

resource "aws_iam_policy" "vk_user_a_policy" {
  name        = "user-a-policy"
  description = "user-a policy"
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "ListObjectsInBucket",
            "Effect": "Allow",
            "Action": ["s3:ListBucket"],
            "Resource": ["${aws_s3_bucket.vk_bucket_a.arn}"]
        },
        {
            "Sid": "AllObjectActions",
            "Effect": "Allow",
            "Action": "s3:*Object",
            "Resource": ["${aws_s3_bucket.vk_bucket_a.arn}/*"]
        }
    ]
}
    EOF
}

resource "aws_iam_user_policy_attachment" "user_a_attach" {
  user       = aws_iam_user.vk_user_a.name
  policy_arn = aws_iam_policy.vk_user_a_policy.arn
}


resource "aws_iam_user" "vk_user_b" {
  name = "user-b"
}

resource "aws_iam_policy" "vk_user_b_policy" {
  name        = "user-b-policy"
  description = "user-b policy"
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "ListObjectsInBucket",
            "Effect": "Allow",
            "Action": ["s3:ListBucket"],
            "Resource": ["${aws_s3_bucket.vk_bucket_b.arn}"]
        },
        {
            "Sid": "AllObjectActions",
            "Effect": "Allow",
            "Action": "s3:GetObject*",
            "Resource": ["${aws_s3_bucket.vk_bucket_b.arn}/*"]
        }
    ]
}
    EOF
}

resource "aws_iam_user_policy_attachment" "user_b_attach" {
  user       = aws_iam_user.vk_user_b.name
  policy_arn = aws_iam_policy.vk_user_b_policy.arn
}