terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.51.0"
    }
  }
}

provider "google" {
  credentials = file("/home/algchoo/cka-training/cka-training-sa.json")

  project = "cka-training-417322"
  region  = "us-central1"
  zone    = "us-central1-c"
}

resource "google_compute_network" "vpc_network" {
  name = "lfclass"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "lfclass-subnet" {
  name          = "lfclass"
  ip_cidr_range = "10.2.0.0/16"
  region        = "us-central1"
  network       = google_compute_network.vpc_network.id
}

resource "google_compute_firewall" "vpc-fw-rule" {
  name    = "test-firewall"
  network = google_compute_network.vpc_network.name

  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "all"
  }
}

resource "google_compute_network" "default" {
  name = "test-network"
}
