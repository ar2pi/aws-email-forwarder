output "tfstate_bucket_arn" {
  value = aws_s3_bucket.tfstate_bucket.arn
}

output "tfstate_lock_table_arn" {
  value = aws_dynamodb_table.tfstate_lock.arn
}
