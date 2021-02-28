module "code-build" {
  source      = "../modules/code-build"
  website_bucket_name = "static-website-bucket-test-asdsadas" 
  code_build_project_name = "static-website-cicd"
}

module "code-pipeline" {
  source      = "../modules/code-pipeline"
  code_pipeline_name = "CodePipeline"
  code_build_project_name = "static-website-cicd"
}


