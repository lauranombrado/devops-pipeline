
Reference:
https://centricconsulting.com/blog/blog-series-how-to-put-ci-pipeline-in-cloud-using-aws-with-terraform_devops/


Setup AWS IAM user:
- terraform-user programmatic access with administrative account
- ecr-remote-pusher programmatic access with 2 policies: AmazonEC2ContainerRegistryPowerUser and AmazonECSFull

Setup Tools:
After installing the AWS CLI, GIT CLI and Terraform CLI, complete the following tasks:
- Verify AWS CLI installation 
- Verify terraform CLI installation 
- Verify GIT CLI installation 
- Configure an AWS CLI profile to be used with terraform to access the AWS account 
- Validate command-line access to your AWS account   


Terraform the AWS Infrastructure:
<br> terraform init
<br> terraform plan
<br> terraform apply --auto-approve
<br> terraform destroy --auto-approve

