variable "region" {
  default = "us-east-1"
}

variable "zones" {
  default = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "vpc_ip_cidr" {
  default = "172.10.0.0/16"
}

variable "vpc_pub_subnets" {

  default = ["172.10.1.0/24", "172.10.2.0/24", "172.10.3.0/24"]
}

variable "vpc_priv_subnets" {

  default = ["172.10.5.0/24", "172.10.6.0/24", "172.10.7.0/24"]
}

variable "machine-name-tags" {
  type = set(string)
  default = ["jenkinsserver","kubecontroller"]
}

variable "allow-ports" {
  default = {
    "ssh"  = 22,
    "http" = 80,
    "tcp" = 8080
  }
}

variable "amis" {
  type = map(any)
  default = {
    us-east-1 = "ami-002070d43b0a4f171"
    us-east-2 = "ami-05a36e1502605b4aa"
  }

}

variable "key_name" {
  default = "kube-key"
}


variable "bucket_folders" {

  type    = set(string)
  default = ["kops-state"]
}

variable "bucket_name" {
  type = set(string)
  default = ["trust-kops-state"]
}


variable "my-ip" {
  default = "0.0.0.0/0"
}

variable "cluster_domain_name" {

  default = "kube.teslaacademic.online"
  
}

variable "default_user" {
  default ="centos"
}