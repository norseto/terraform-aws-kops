# Bucket for IRSA OIDC discovery
resource "aws_s3_bucket" "s3_bucket_discovery" {
  bucket = "${local.prefix}${local.discovery_name}"
}

resource "aws_s3_bucket_versioning" "s3_bucket_discovery" {
  bucket = aws_s3_bucket.s3_bucket_discovery.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "s3_bucket_discovery" {
  bucket = aws_s3_bucket.s3_bucket_discovery.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_acl" "s3_bucket_discovery" {
  bucket = aws_s3_bucket.s3_bucket_discovery.id
  depends_on = [
    aws_s3_bucket_ownership_controls.s3_bucket_discovery,
    aws_s3_bucket_public_access_block.s3_bucket_discovery
  ]
  acl = "private"
}

resource "aws_s3_bucket_ownership_controls" "s3_bucket_discovery" {
  bucket = aws_s3_bucket.s3_bucket_discovery.id
  rule {
    object_ownership = "ObjectWriter"
  }
}

resource "aws_s3_bucket_public_access_block" "s3_bucket_discovery" {
  bucket = aws_s3_bucket.s3_bucket_discovery.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}
