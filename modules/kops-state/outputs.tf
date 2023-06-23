output "s3_bucket_id" {
  description = "State storage bucket ID"
  value       = aws_s3_bucket.kops_state.id
}

output "KOPS_STATE_STORE" {
  description = "State storage bucket ID for environment"
  value       = "s3://${aws_s3_bucket.kops_state.id}"
}

output "s3_discovery_bucket_id" {
  description = "State storage bucket ID"
  value       = aws_s3_bucket.s3_bucket_discovery.id
}
