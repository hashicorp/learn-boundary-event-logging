# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

disable_mlock = true

controller {
  name = "docker-controller"
  description = "A controller for a docker demo!"
  address = "boundary"
  database {
      url = "env://BOUNDARY_PG_URL"
  }
}

listener "tcp" {
  address = "0.0.0.0:9200"
  purpose = "api"
  tls_disable = true
  cors_enabled = true
	cors_allowed_origins = ["*"]
}

listener "tcp" {
  address = "boundary"
  purpose = "cluster"
  tls_disable = true
}

listener "tcp" {
  address = "0.0.0.0:9203"
	purpose = "ops"
	tls_disable = true
}

kms "aead" {
  purpose = "root"
  aead_type = "aes-gcm"
  key = "sP1fnF5Xz85RrXyELHFeZg9Ad2qt4Z4bgNHVGtD6ung="
  key_id = "global_root"
}

kms "aead" {
  purpose = "worker-auth"
  aead_type = "aes-gcm"
  key = "8fZBjCUfN0TzjEGLQldGY4+iE9AkOvCfjh7+p0GtRBQ="
  key_id = "global_worker-auth"
}

kms "aead" {
  purpose = "recovery"
  aead_type = "aes-gcm"
  key = "8fZBjCUfN0TzjEGLQldGY4+iE9AkOvCfjh7+p0GtRBQ="
  key_id = "global_recovery"
}

events {
  audit_enabled        = true
  observations_enabled = true
  sysevents_enabled    = true

  sink "stderr" {
    name        = "all-events"
    description = "All events sent to stderr"
    event_types = ["*"]
    format      = "cloudevents-json"
  }

  sink {
    name        = "controller-audit-sink"
    description = "Audit sent to a file"
    event_types = ["audit"]
    format      = "cloudevents-json"

    file {
      path      = "/logs"
      file_name = "controller.log"
    }

    audit_config {
      audit_filter_overrides {
        secret    = "encrypt"
        sensitive = "hmac-sha256"
      }
    }
  }

  // sink {
  //   name = "auth-sink"
  //   description = "Authentications sent to a file"
  //   event_types = ["observation"]
  //   format = "cloudevents-json"
  //   allow_filters = [
  //     "\"/data/request_info/path\" contains \":authenticate\""
  //   ]
  //   file {
  //     path = "/logs/"
  //     file_name = "auth.log"
  //   }
  // }
}
