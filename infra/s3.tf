resource "aws_s3_bucket" "firehose_dead_letter_queue" {
  bucket        = "${var.project}-firehose-dead-letter"
  force_destroy = true

  tags = {
    env = "dev"
  }
}

resource "aws_s3_bucket_public_access_block" "firehose_dead_letter_queue_block" {
  bucket = aws_s3_bucket.firehose_dead_letter_queue.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
