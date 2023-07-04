# resource "aws_key_pair" "dove-key" {
#   key_name   = "dovekey"
#   public_key = file("dovekey.pub")
# }

resource "aws_route53_zone" "dev" {
  name = "${var.cluster_domain_name}"

  tags = {
    environment = "Development"
  }
}

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
  for_each = var.bucket_name
  bucket = each.value
  #acl    = "public-read"
  tags = {
    Name = "${each.value}"
  }
}


# resource "aws_s3_bucket_ownership_controls" "ownership" {
#   for_each = aws_s3_bucket.states
#   bucket = each.value.bucket
#   rule {
#     object_ownership = "BucketOwnerPreferred"
#   }
# }

# resource "aws_s3_bucket_public_access_block" "access" {
#   for_each = aws_s3_bucket.states
#   bucket = each.value.bucket

#   block_public_acls       = false
#   block_public_policy     = false
#   ignore_public_acls      = false
#   restrict_public_buckets = false
# }

# resource "aws_s3_bucket_acl" "acl" {
#   depends_on = [
#     aws_s3_bucket_ownership_controls.access,
#     aws_s3_bucket_public_access_block.access,
#   ]

#   for_each = aws_s3_bucket.states
#   bucket = each.value.bucket
#   acl    = "public-read"
# }

resource "aws_s3_object" "object" {
  for_each = aws_s3_bucket.states
  bucket = each.value.bucket
  key      = "tf_states/"
}

data "template_file" "userdata" {
  template = file("${abspath(path.module)}/web.sh")
}

output "publicIp" {
  value = { for tag in var.machine-name-tags : tag => aws_instance.dove-inst[tag].public_ip }
}


