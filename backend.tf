terraform {
  backend "s3" {
    bucket = "HA-14-11-Bucket"
    key    = "ha-datei.tfstate/ha-ordner-14-11"
    region = "eu-central-1"
  }
}
