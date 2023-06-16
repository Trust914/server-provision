resource "aws_key_pair" "dove-key" {
  key_name   = "dovekey"
  public_key = file("dovekey.pub")
}

resource "aws_instance" "dove-inst" {
  ami                    = var.amis[var.region]
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.pub-sub[0].id
  key_name               = aws_key_pair.dove-key.key_name
  vpc_security_group_ids = [aws_security_group.group-rules.id]
  user_data              = data.template_file.userdata.rendered
  tags = {
    Name    = "Dove-Instance"
    Project = "Dove"
  }


}

resource "aws_s3_bucket" "tf_state" {
  bucket = var.bucket_name
  tags = {
    Name = "Terraform state"
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
