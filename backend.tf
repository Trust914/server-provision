terraform {
  backend "s3" {
    bucket = "trust-terra-state"
    key    = "tf_states"
    region = "us-east-1"
  }
}
