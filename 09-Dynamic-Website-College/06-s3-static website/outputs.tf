output "bucket_name" {
  description = "The name of the S3 bucket created for the website."
  value       = aws_s3_bucket.website_bucket.id
}

output "website_endpoint" {
  description = "The S3 website endpoint (regional)."
  value       = aws_s3_bucket.website_bucket.website_endpoint
}

output "website_url" {
  description = "Full HTTP URL for the website endpoint."
  value       = "http://${aws_s3_bucket.website_bucket.website_endpoint}"
}
