resource "tls_private_key" "standalone_bastion" {
  algorithm = "ED25519"
}

resource "random_password" "worker" {
  length           = 32
  special          = true
  min_lower        = 1
  min_upper        = 1
  min_numeric      = 1
  min_special      = 1
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "random_password" "target" {
  length           = 32
  special          = true
  min_lower        = 1
  min_upper        = 1
  min_numeric      = 1
  min_special      = 1
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "local_sensitive_file" "standalone_bastion_private_key" {
  content         = tls_private_key.standalone_bastion.private_key_openssh
  filename        = "${path.module}/.ssh/bastion-host-ed25519"
  file_permission = "0600"
}

resource "local_file" "standalone_bastion_public_key" {
  content         = tls_private_key.standalone_bastion.public_key_openssh
  filename        = "${path.module}/.ssh/bastion-host-ed25519.pub"
  file_permission = "0644"
}

resource "local_sensitive_file" "worker_password" {
  content         = random_password.worker.result
  filename        = "${path.module}/.secrets/WorkerNode-password.txt"
  file_permission = "0600"
}

resource "local_sensitive_file" "target_password" {
  content         = random_password.target.result
  filename        = "${path.module}/.secrets/TargetVM-password.txt"
  file_permission = "0600"
}
