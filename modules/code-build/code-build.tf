data "aws_iam_policy_document" "code_build_policy_document" {
    statement {
      sid = "1"
      effect = "Allow"
      actions = [ 
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
       ]
       resources = [ "*" ]
    }
    statement {
     sid = "2" 
     effect = "Allow"
     actions = [ "s3:*" ]
     resources = [ 
        "arn:aws:s3:::${var.website_bucket_name}",
        "arn:aws:s3:::${var.website_bucket_name}/*"
      ]
    }
    
}
resource "aws_iam_role" "CodeBuildExecutionRole" {
  name = "CodeBuildExecutionRole-tf-challenge"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "CodeBuildPolicy" {
  role = aws_iam_role.CodeBuildExecutionRole.name

  policy = data.aws_iam_policy_document.code_build_policy_document.json
}

resource "aws_codebuild_project" "code_build" {
  name          = var.code_build_project_name
  build_timeout = "5"
  service_role  = aws_iam_role.CodeBuildExecutionRole.arn

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:5.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
  }
  artifacts {
    type = "CODEPIPELINE"
  }
  source {
    type = "CODEPIPELINE"
  }
  # logs_config {
  #   cloudwatch_logs {
  #     group_name  = "CodeBuildTerraformChallengeLogGroup"
  #     stream_name = "CodeBuildTerraformChallengeLogStream"
  #   }
  # }
}

