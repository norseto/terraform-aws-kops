/**
 * Set up State Bucket for kOps.
 * See : https://kops.sigs.k8s.io/getting_started/aws/
 *
 * This terraform module create 2 buckets:
 * - One for State Store
 * - One for IRSA OIDC Discovery
 *
 * The bucket for IRSA OIDC Discovery should be able to public accessible,
 * we use random pet for its name. 
 */
# Bucket for kOps state
resource "aws_s3_bucket" "kops_state" {
  bucket = "${local.prefix}${local.state_name}${local.state_suffix}"
}

resource "aws_s3_bucket_versioning" "kops_state" {
  bucket = aws_s3_bucket.kops_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "kops_state" {
  bucket = aws_s3_bucket.kops_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_acl" "kops_state" {
  bucket = aws_s3_bucket.kops_state.id
  depends_on = [
    aws_s3_bucket_ownership_controls.kops_state,
    aws_s3_bucket_public_access_block.kops_state
  ]
  acl = "private"
}

resource "aws_s3_bucket_ownership_controls" "kops_state" {
  bucket = aws_s3_bucket.kops_state.id
  rule {
    object_ownership = "ObjectWriter"
  }
}

resource "aws_s3_bucket_public_access_block" "kops_state" {
  bucket = aws_s3_bucket.kops_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
