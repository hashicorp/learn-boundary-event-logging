# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

// compose/worker.hcl

disable_mlock = true

listener "tcp" {
	address = "worker"
	purpose = "proxy"
	tls_disable = true
}

worker {
  name = "worker"
  description = "A worker for a docker demo"
  address     = "worker"
  public_addr = "localhost:9202"
  controllers = ["boundary"]
}

kms "aead" {
  purpose = "worker-auth"
  aead_type = "aes-gcm"
  key = "8fZBjCUfN0TzjEGLQldGY4+iE9AkOvCfjh7+p0GtRBQ="
  key_id = "global_worker-auth"
}
