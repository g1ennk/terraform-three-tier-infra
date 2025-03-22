# S3 버킷 생성
resource "aws_s3_bucket" "static_site" {
  bucket        = var.bucket_name
  force_destroy = true # 버킷에 객체가 있어도 삭제 가능

  tags = merge(var.common_tags, { Name = var.bucket_name })
}

# S3 버킷의 오브젝트 소유권 설정
resource "aws_s3_bucket_ownership_controls" "ownership" {
  bucket = aws_s3_bucket.static_site.id

  rule {
    object_ownership = "BucketOwnerPreferred" # 업로더와 무관하게 버킷 소유자가 객체 소유
  }
}

# 퍼블릭 접근 차단 설정
resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.static_site.id

  block_public_acls       = true # 퍼블릭 ACL 차단
  block_public_policy     = true # 퍼블릭 정책 차단
  ignore_public_acls      = true # 퍼블릭 ACL 무시
  restrict_public_buckets = true # 퍼블릭 설정된 버킷 자체의 액세스 제한
}

# S3 정적 웹사이트 호스팅 설정
resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.static_site.id

  index_document {
    suffix = "index.html" # 메인 페이지 파일
  }

  error_document {
    key = "index.html" # 라우팅 fallback?
  }
}

# S3 버킷에 CloudFront에서만 접근 가능하도록 설정
resource "aws_s3_bucket_policy" "static_policy" {
  bucket = aws_s3_bucket.static_site.id
  policy = data.aws_iam_policy_document.s3_policy.json
}

# IAM 정책 문서 정의: CloudFront 서비스만 이 버킷 객체를 읽을 수 있도록 허용
data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions   = ["s3:GetObject"]                       # 읽기 권한
    resources = ["${aws_s3_bucket.static_site.arn}/*"] # 버킷 내 모든 객체에 적용
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"] # CloudFront 서비스만 허용
    }
  }
}
