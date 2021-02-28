module "s3-static-website" {
  source      = "../modules/s3-static-website"
  bucket_name = "static-website-bucket-test-asdsadas"
}

output "website_endpoint" {
  value = module.s3-static-website.website_endpoint
}

