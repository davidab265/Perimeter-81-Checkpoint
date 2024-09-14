terraform {
  backend "s3" {}
}


provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = var.tags
  }
}

# S3 Bucket
resource "aws_s3_bucket" "json_file" {
  bucket = var.bucket_name

}

# S3 Bucket Policy - allows access to the bucket only with the cloudfront domain
resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.json_file.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowCloudFrontAccess"
        Effect    = "Allow"
        Principal = {
          AWS = aws_cloudfront_origin_access_identity.oai.iam_arn
        }
        Action   = "s3:GetObject"
        Resource = "${aws_s3_bucket.json_file.arn}/*"
      }
    ]
  })
}

# CloudFront Distribution
resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = aws_s3_bucket.json_file.bucket_regional_domain_name
    origin_id   = "S3Origin"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.oai.cloudfront_access_identity_path
    }
  }

  enabled             = true
  default_root_object = "filtered_products.json"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3Origin"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

# CloudFront Origin Access Identity
resource "aws_cloudfront_origin_access_identity" "oai" {
  comment = "OAI for ${var.bucket_name}"
}

# Output the CloudFront Domain Name - will be used later in the pipeline and the python script
output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.s3_distribution.domain_name
}

# can be used if you want to use a environment variable in the python script to get the bucket name
# output "aws_s3_bucket_name" {
#   value = aws_s3_bucket.json_file.bucket
# }
