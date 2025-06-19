terraform {
  backend "s3" {
    bucket     = "terrafrom-testing-bucket-uipl"
    key        = "newdev/backend/newtest"
    region     = "us-east-1" 
    #use_lockfile = true  #S3 native locking
    
    assume_role = {
    role_arn = "arn:aws:iam::296062546708:role/terraform-deployment-test-role"
    session_name = "terraform-session"
  }
  }
}

