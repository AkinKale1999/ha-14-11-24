terraform {
  backend "s3" {
    bucket = "ha-14-11-bucket"
    key    = "ha-datei.tfstate/ha-ordner-14-11"
    region = "eu-central-1"
  }
}


# s3 name in AWS darf keine GROß Buchstaben haben
