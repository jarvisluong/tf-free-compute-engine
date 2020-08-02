provider "google" {
  credentials = file("account.json")
  project     = "personal-259706"
  region      = "us-central1"
}

resource "google_compute_instance" "free_gcp_compute_engine" {
  name         = "free-gcp"
  machine_type = "f1-micro"
  zone         = "us-central1-a"

  allow_stopping_for_update = true

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
      size = 10
    }
  }

  network_interface {
    network = google_compute_network.free_gcp_network.self_link

    access_config {
      nat_ip = google_compute_address.static.address
    }
  }

  metadata = {
    foo = "bar"
  }

  metadata_startup_script = "echo hi > /test.txt"

  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }
}

resource "google_compute_network" "free_gcp_network" {
  name = "free-gcp-network"
}

resource "google_compute_address" "static" {
  name = "free-gcp-ipv4"
}

resource "google_compute_firewall" "free_gcp_firewall" {
  name    = "allow-ssh"
  network = google_compute_network.free_gcp_network.self_link

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}

