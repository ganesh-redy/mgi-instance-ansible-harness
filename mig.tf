provider "google" {
  credentials = file("file.json")
  project     = "sam-458313"
  zone        = "us-central1-a"
}

# Step 1: Generate SSH Key
resource "tls_private_key" "my_ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Step 2: Instance Template with SSH key in metadata
resource "google_compute_instance_template" "temp1" {
  name         = "template1"
  machine_type = "e2-standard-2"

  disk {
    boot         = true
    auto_delete  = true

    initialize_params {
      source_image = "centos-stream-9"
    }
  }

  network_interface {
    network = "default"
  }

  metadata = {
    ssh-keys = "ansible:${tls_private_key.my_ssh_key.public_key_openssh}"
  }
}

# Step 3: Health Check
resource "google_compute_health_check" "name" {
  name = "health1"

  http_health_check {
    port         = 80
    request_path = "/"
  }

  healthy_threshold   = 2
  unhealthy_threshold = 2
  timeout_sec         = 5
  check_interval_sec  = 10
}

# Step 4: Managed Instance Group with 2 VMs
resource "google_compute_instance_group_manager" "mange" {
  name               = "instance-manger-1"
  base_instance_name = "okay"
  zone               = "us-central1-a"

  version {
    instance_template = google_compute_instance_template.temp1.self_link_unique
  }

  target_size = 2

  auto_healing_policies {
    health_check      = google_compute_health_check.name.self_link
    initial_delay_sec = 300
  }
}

# Step 5: Outputs
output "private_key" {
  value     = tls_private_key.my_ssh_key.private_key_pem
  sensitive = true
}

output "public_key" {
  value = tls_private_key.my_ssh_key.public_key_openssh
}
