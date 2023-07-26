#S3 bucket
resource "aws_s3_bucket" "credcomp" {
    bucket = var.credcomp-s3-bucket
    force_destroy = true
}
resource “aws_s3_bucket_public_access_block” “public_access_block” {
  bucket = aws_s3_bucket.credcompromise.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
