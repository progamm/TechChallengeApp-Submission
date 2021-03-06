

provider "aws" {
  region                  = "ap-southeast-2"
  profile                 = "MYAWS"
}

resource "aws_s3_bucket" "getcode" {
  bucket = "getcode"
}

resource "aws_s3_bucket_public_access_block" "getcode" {
  bucket = aws_s3_bucket.getcode.id

  block_public_acls   = false
  block_public_policy = false
  restrict_public_buckets =false
  ignore_public_acls = false
}

resource "aws_iam_role" "getcode" {
  name = "getcode"

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
resource "aws_iam_role_policy" "getcode" {
  role = aws_iam_role.getcode.name

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Resource": [
        "*"
      ],
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:CreateNetworkInterface",
        "ec2:DescribeDhcpOptions",
        "ec2:DescribeNetworkInterfaces",
        "ec2:DeleteNetworkInterface",
        "ec2:DescribeSubnets",
        "ec2:DescribeSecurityGroups",
        "ec2:DescribeVpcs"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:CreateNetworkInterfacePermission"
      ],
      "Resource": [
        "arn:aws:ec2:ap-southeast-2:123456789012:network-interface/*"
      ],
      "Condition": {
        "StringEquals": {
          "ec2:AuthorizedService": "codebuild.amazonaws.com"
        }
      }
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:*"
      ],
      "Resource": [
        "${aws_s3_bucket.getcode.arn}",
        "${aws_s3_bucket.getcode.arn}/*"
      ]
    }
  ]
}
POLICY
}
resource "aws_s3_bucket_policy" "C" {
  bucket = aws_s3_bucket.getcode.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression's result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "MYBUCKETPOLICY"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        "Action": "s3:GetObject",
        Resource = [
          aws_s3_bucket.getcode.arn,
          "${aws_s3_bucket.getcode.arn}/*",
        ]
        
      },
    ]
  })
}
resource "aws_iam_policy" "AWSCodePipelineServiceRole-ap-southeast-2-github" {
  name        = "AWSCodePipelineServiceRole-ap-southeast-2-github"
  path        = "/"

  policy = <<EOF
{
    "Statement": [
        {
            "Action": [
                "iam:PassRole"
            ],
            "Resource": "*",
            "Effect": "Allow",
            "Condition": {
                "StringEqualsIfExists": {
                    "iam:PassedToService": [
                        "cloudformation.amazonaws.com",
                        "elasticbeanstalk.amazonaws.com",
                        "ec2.amazonaws.com",
                        "ecs-tasks.amazonaws.com"
                    ]
                }
            }
        },
        {
            "Action": [
                "codecommit:CancelUploadArchive",
                "codecommit:GetBranch",
                "codecommit:GetCommit",
                "codecommit:GetUploadArchiveStatus",
                "codecommit:UploadArchive"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Action": [
                "codedeploy:CreateDeployment",
                "codedeploy:GetApplication",
                "codedeploy:GetApplicationRevision",
                "codedeploy:GetDeployment",
                "codedeploy:GetDeploymentConfig",
                "codedeploy:RegisterApplicationRevision"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Action": [
                "elasticbeanstalk:*",
                "ec2:*",
                "elasticloadbalancing:*",
                "autoscaling:*",
                "cloudwatch:*",
                "s3:*",
                "sns:*",
                "cloudformation:*",
                "rds:*",
                "sqs:*",
                "ecs:*"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Action": [
                "lambda:InvokeFunction",
                "lambda:ListFunctions"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Action": [
                "opsworks:CreateDeployment",
                "opsworks:DescribeApps",
                "opsworks:DescribeCommands",
                "opsworks:DescribeDeployments",
                "opsworks:DescribeInstances",
                "opsworks:DescribeStacks",
                "opsworks:UpdateApp",
                "opsworks:UpdateStack"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Action": [
                "cloudformation:CreateStack",
                "cloudformation:DeleteStack",
                "cloudformation:DescribeStacks",
                "cloudformation:UpdateStack",
                "cloudformation:CreateChangeSet",
                "cloudformation:DeleteChangeSet",
                "cloudformation:DescribeChangeSet",
                "cloudformation:ExecuteChangeSet",
                "cloudformation:SetStackPolicy",
                "cloudformation:ValidateTemplate"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Action": [
                "codebuild:BatchGetBuilds",
                "codebuild:StartBuild"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Effect": "Allow",
            "Action": [
                "devicefarm:ListProjects",
                "devicefarm:ListDevicePools",
                "devicefarm:GetRun",
                "devicefarm:GetUpload",
                "devicefarm:CreateUpload",
                "devicefarm:ScheduleRun"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "servicecatalog:ListProvisioningArtifacts",
                "servicecatalog:CreateProvisioningArtifact",
                "servicecatalog:DescribeProvisioningArtifact",
                "servicecatalog:DeleteProvisioningArtifact",
                "servicecatalog:UpdateProduct"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "cloudformation:ValidateTemplate"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ecr:DescribeImages"
            ],
            "Resource": "*"
        }
    ],
    "Version": "2012-10-17"
}
EOF
}

#builds the service role for codepipeline
resource "aws_iam_role" "AWSCodePipelineServiceRole-ap-southeast-2-github" {
  name = "AWSCodePipelineServiceRole-ap-southeast-2-github"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

#attach the policy to the service role
resource "aws_iam_role_policy_attachment" "AWSCodePipelineServiceRole-ap-southeast-2-github" {
  role       = "${aws_iam_role.AWSCodePipelineServiceRole-ap-southeast-2-github.name}"
  policy_arn = "${aws_iam_policy.AWSCodePipelineServiceRole-ap-southeast-2-github.arn}"
}

resource "aws_s3_bucket" "codepipeline-ap-southeast-2-myartifacts" {
  bucket = "codepipeline-ap-southeast-2-myartifacts"
  acl    = "private"
}
resource "aws_s3_bucket_public_access_block" "codepipeline-ap-southeast-2-myartifacts" {
  bucket = aws_s3_bucket.codepipeline-ap-southeast-2-myartifacts.id

  block_public_acls   = false
  block_public_policy = false
  restrict_public_buckets =false
  ignore_public_acls = false
}
resource "aws_s3_bucket_policy" "n" {
  bucket = aws_s3_bucket.codepipeline-ap-southeast-2-myartifacts.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression's result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "MYBUCKETPOLICY"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        "Action": "s3:GetObject",
        Resource = [
          aws_s3_bucket.codepipeline-ap-southeast-2-myartifacts.arn,
          "${aws_s3_bucket.codepipeline-ap-southeast-2-myartifacts.arn}/*",
        ]
        
      },
    ]
  })
}
resource "aws_codepipeline" "github" {
  name     = "github-pipeline"
  role_arn = "${aws_iam_role.AWSCodePipelineServiceRole-ap-southeast-2-github.arn}"
  

  artifact_store {
    location = "${aws_s3_bucket.codepipeline-ap-southeast-2-myartifacts.bucket}"
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["SourceArtifact"]

      configuration = {
        Owner  = "progamm"
        Repo   = "TechChallengeApp"
        Branch = "master"
        OAuthToken = "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"
        
      }
    }
  }
   stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["SourceArtifact"]
      output_artifacts = ["build_output"]
      version          = "1"

      configuration = {
        ProjectName = "mzharbuild"
      }
    }
  }

  

  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "S3"
      input_artifacts = ["SourceArtifact"]
      version         = "1"

     configuration = {
        BucketName = "mazharbucket"
        Extract = "true"
      }
    }
  }
}

locals {
  webhook_secret = "super-secret"
}

resource "aws_codepipeline_webhook" "webhook" {
  name            = "webhook"
  authentication  = "GITHUB_HMAC"
  target_action   = "Source"
  target_pipeline = "${aws_codepipeline.github.name}"

  authentication_configuration {
    secret_token = "${local.webhook_secret}"
  }

  filter {
    json_path    = "$.ref"
    match_equals = "refs/heads/{Branch}"
  }
}


