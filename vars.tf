variable "instance" {
  type = map(any)
  default = {
    "count"       = "3"
    "size"        = "c4.xlarge"
    "key_name"    = "roman"
    "rootfs_size" = "30"
    #"ami"         = "ami-047a51fa27710816e" # amazon linux 2
    "ami"         = "ami-0d6e9a57f6259ba3a" #  centos 8
  }
}

variable "zone" {
  type = map(any)
  default = {
    "name"   = "columnstore.mariadb.net"
    "prefix" = "cs"
  }
}

variable "bucket" {
  default = "cs-s3-stage"
}
