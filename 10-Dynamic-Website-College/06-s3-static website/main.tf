terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

resource "aws_s3_bucket" "website_bucket" {
  bucket        = var.bucket_name != "" ? var.bucket_name : null
  acl           = "private"
  force_destroy = var.force_destroy

  website {
    index_document = "index.html"
    error_document = "error.html"
  }

  tags = {
    Name      = "s3-static-website"
    ManagedBy = "terraform"
  }
}

resource "aws_s3_bucket_public_access_block" "website_block" {
  count = var.public_website ? 1 : 0
  bucket = aws_s3_bucket.website_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "public_read" {
  count  = var.public_website ? 1 : 0
  bucket = aws_s3_bucket.website_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "PublicReadGetObject"
        Effect = "Allow"
        Principal = "*"
        Action = ["s3:GetObject"]
        Resource = ["${aws_s3_bucket.website_bucket.arn}/*"]
      }
    ]
  })
}

resource "aws_s3_bucket_object" "index" {
  bucket       = aws_s3_bucket.website_bucket.id
  key          = "index.html"
  content      = file("${path.module}/index.html")
  content_type = "text/html"
}
