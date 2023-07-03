# resource "aws_key_pair" "dove-key" {
#   key_name   = "dovekey"
#   public_key = file("dovekey.pub")
# }

resource "tls_private_key" "my_key" {
  algorithm = "RSA"
}

resource "aws_key_pair" "deployer" {
  key_name   = var.key_name
  public_key = tls_private_key.my_key.public_key_openssh

  provisioner "local-exec" {
    command = <<-EOT
      echo '${tls_private_key.my_key.private_key_pem}' > '${var.key_name}'.pem
      chmod 400 '${var.key_name}'.pem
    EOT
  }
}
resource "aws_instance" "dove-inst" {
  for_each = var.machine-name-tags
  ami                    = var.amis[var.region]
  count = length(var.machine-name-tags)
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.pub-sub[0].id
  key_name               = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.group-rules.id]
  user_data              = data.template_file.userdata.rendered
  tags = {
    Name    = "${each.value}"
    environment = "Development"
    stack = "kube-stack"
  }

}

resource "aws_s3_bucket" "states" {
  for_each = var.bucket_names
  bucket = each.value
  tags = {
    Name = "${each.value}"
  }
}


resource "aws_s3_object" "object" {
  for_each = var.bucket_folders
  bucket   = aws_s3_bucket.tf_state.id
  key      = "${each.value}/"
}

data "template_file" "userdata" {
  template = file("${abspath(path.module)}/web.sh")
}

output "publicIp" {
  value = aws_instance.dove-inst.public_ip

}
