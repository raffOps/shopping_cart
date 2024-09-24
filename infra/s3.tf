resource "aws_s3_bucket" "firehose-dead-letter-queue" {
  bucket = "${var.project}-firehose-dead-letter"
  force_destroy = true
  tags = {
    env = "dev"
  }
}