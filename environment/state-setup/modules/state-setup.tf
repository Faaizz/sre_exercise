resource "aws_s3_bucket" "state_storage" {
  bucket = "state.${var.cluster_name}"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = false 
  }

  tags = {
    Name = "State storage for ${var.cluster_name}"
  }
}

resource "aws_dynamodb_table" "dynamodb-state-lock" {
  name           = "state.${var.cluster_name}"
  hash_key       = "LockID"
  read_capacity  = 20
  write_capacity = 20

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = "Lock table for ${var.cluster_name}"
  }
}
