resource "aws_efs_file_system" "efs-file-system" {
  encrypted                       = "true"
  performance_mode                = "generalPurpose"
  provisioned_throughput_in_mibps = "0"
  throughput_mode                 = "bursting"
}

resource "aws_efs_mount_target" "test-efs-mount-target" {
  count = "${length(local.private_subnet_ids)}"

  file_system_id  = aws_efs_file_system.efs-file-system.id
  security_groups = [aws_security_group.this.id]
  subnet_id       = "${element(local.private_subnet_ids, count.index)}"
}