variable "bucket_name" {
  description = "Optional: explicit bucket name. Leave empty to let Terraform create one."
  type        = string
  default     = ""
}

variable "public_website" {
  description = "When true, create a public-read policy for objects so the website is accessible."
  type        = bool
  default     = true
}

variable "force_destroy" {
  description = "Allow Terraform to destroy the bucket even if it contains objects."
  type        = bool
  default     = false
}
