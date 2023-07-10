output "publicIp" {
  value = { for tag in var.machine-name-tags : tag => aws_instance.dove-inst[tag].public_ip }
}

output "sshJenkins" {
  value = "ssh -i ${var.key_name}.pem centos@${aws_instance.dove-inst["jenkinsserver"].public_ip}"
}

output "Jenkins_Password_Retrieval" {
    value = "sudo cat /home/${var.default_user}/jenkins_configuration//secrets/initialAdminPassword"
}