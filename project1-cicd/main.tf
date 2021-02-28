module "code-build" {
  source      = "../modules/code-build"
  website_bucket_name = "static-website-bucket-test-abc-1" 
  code_build_project_name = "static-website-cicd"
  code_pipeline_bucket_name = "nb-code-pipeline-bucket-randasoiqwjoi"
}

module "code-pipeline" {
  source      = "../modules/code-pipeline"
  code_pipeline_name = "CodePipeline"
  code_build_project_name = "static-website-cicd"
  code_pipeline_bucket_name = "nb-code-pipeline-bucket-randasoiqwjoi"
}


