output "image_name" {
  description = "AMI image name"
  value       = try(data.aws_ami.this[0].name, "")
}

output "image_id" {
  description = "AMI image ID"
  value       = try(data.aws_ami.this[0].image_id, "")
}

output "owner_id" {
  description = "AMI image owner ID"
  value       = try(data.aws_ami.this[0].owner_id, "")
}

output "image_full_name" {
  description = "AMI image full name"
  value       = try("${data.aws_ami.this[0].owner_id}/${data.aws_ami.this[0].name}", "")
}
