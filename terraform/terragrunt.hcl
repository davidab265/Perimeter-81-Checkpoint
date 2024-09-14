# set the path to the remote state file (tfstate file)
remote_state {
  backend = "s3"
  config = {
    bucket         = "david-abrams-checkpoint-tfstate"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "david-abrams-checkpoint-tfstate"
  }
}

# set the variables
inputs = {
  region      = "us-east-1"
  bucket_name = "david-abrams-checkpoint"
  owner_name  = "David Abrams"
  tags = {
     Name      = "ProductCloudFront"
     Owner     = "David Abrams"
     Terraform = "True"
   }

}