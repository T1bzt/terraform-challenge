1. set your provider in /project1-cicd/provider.tf
2. cd/project1-cdcd
3. terraform apply
now you have deployed a ci/cd pipeline. Go to console and confirm the connection of the pipeline to your git repo
4. cd/project2-static-website/terraform
5. set your provider
5. terraform apply
now you have deployed the infrastructure of the static website
6. push the code in /project2-static-website/webiste to github, and the ci/cd will automatically deploy the static webiste to 3
7. cd/project3-python-app/terraform
7. set your provider
8. terraform apply
now you have deployed the infrastructure vpc-ec2-rds, the ec2 will host the website (almost rdy)
9. push the code of /project3-python-app/python-app to git, and this will trigger a pipeline. CodeBuild -> ECR -> CodeDeploy (not rdy)