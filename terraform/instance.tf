data "template_file" "user_data" {
  template = file("cloudinit.yml")
}

resource "aws_instance" "instance" {
  count                  = var.instance.count
  instance_type          = var.instance.size
  ami                    = var.instance.ami
  subnet_id              = aws_subnet.subnet.id
  vpc_security_group_ids = [aws_security_group.security-instance.id, aws_security_group.security-instance-to-efs.id]
  key_name               = var.instance.key_name
  root_block_device {
    volume_size = var.instance.rootfs_size
  }
  user_data = data.template_file.user_data.rendered
}

#resource "aws_instance" "minio" {
#  count                  = var.minio.count
#  instance_type          = var.minio.size
#  ami                    = var.instance.ami
#  subnet_id              = aws_subnet.subnet.id
#  vpc_security_group_ids = [aws_security_group.security-instance.id, aws_security_group.security-instance-to-efs.id]
#  key_name               = var.instance.key_name
#  root_block_device {
#    volume_size = var.instance.rootfs_size
#  }
#  user_data = data.template_file.user_data.rendered
#}
