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
    name        = "worker-sink"
    description = "Audit sent to a file"
    event_types = ["*"]
    format      = "cloudevents-json"

    file {
      path      = "/logs"
      file_name = "worker.log"
    }

    audit_config {
      audit_filter_overrides {
        secret    = "encrypt"
        sensitive = "hmac-sha256"
      }
    }
  }
}