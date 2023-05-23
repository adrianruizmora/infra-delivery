resource "aws_s3_bucket" "terraform_states_backend" {
  bucket = var.backend_bucket_name
  tags = {
    Name = "S3 Remote Terraform State Store"
  }
}

resource "aws_s3_bucket_ownership_controls" "terraform_states_backend" {
  bucket = aws_s3_bucket.terraform_states_backend.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "terraform_states_backend" {
  depends_on = [aws_s3_bucket_ownership_controls.terraform_states_backend]
  bucket     = aws_s3_bucket.terraform_states_backend.id
  acl        = "private"
}

resource "aws_s3_bucket_versioning" "terraform_states_backend" {
  bucket = aws_s3_bucket.terraform_states_backend.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_states_backend" {
  bucket = aws_s3_bucket.terraform_states_backend.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_dynamodb_table" "terraform_states_backend" {
  name           = "${var.backend_bucket_name}-lock"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
  tags = {
    "Name" = "DynamoDB Terraform State Lock Table"
  }
}