resource "random_id" "tfstate" {
  byte_length = 4
}

resource "aws_s3_bucket" "tfstate_bucket" {
  bucket              = "${var.prefix}-tfstate-backend-${random_id.tfstate.hex}"
  object_lock_enabled = true
  tags = {
    Name = "S3 Remote Terraform State Store"
  }
}

resource "aws_s3_bucket_acl" "tfstate_bucket" {
  bucket = aws_s3_bucket.tfstate_bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "tfstate_bucket" {
  bucket = aws_s3_bucket.tfstate_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "tfstate_bucket" {
  bucket = aws_s3_bucket.tfstate_bucket.bucket

  rule {
    bucket_key_enabled = false
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_dynamodb_table" "tfstate_lock" {
  name           = "${var.prefix}-tfstate-lock-${random_id.tfstate.hex}"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
  tags = {
    Name = "DynamoDB Terraform State Lock Table"
  }
}
