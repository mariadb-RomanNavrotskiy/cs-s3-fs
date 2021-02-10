resource "aws_efs_file_system" "efs" {}

resource "aws_efs_mount_target" "target-efs" {
  file_system_id  = aws_efs_file_system.efs.id
  subnet_id       = aws_subnet.subnet.id
  security_groups = [aws_security_group.security-efs.id]
}
