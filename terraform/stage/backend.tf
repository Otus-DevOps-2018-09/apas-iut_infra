terraform {
  backend "gcs" {
    bucket  = "otus-apas-hw7"
    prefix  = "terraform/state"
  }
}
