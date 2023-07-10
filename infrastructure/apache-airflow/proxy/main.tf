resource "google_compute_instance" "proxy_instance" {
    name = "proxy-instance"
    machine_type = var.machine.micro
    zone = var.zone.default
    tags = ["http-server"]
    allow_stopping_for_update = true

    metadata = {
      startup-script = <<-EOF
        #!/bin/bash

        sudo apt-get update -qqq
        sudo apt-get install curl nginx -qqq
        curl https://raw.githubusercontent.com/himewel/airflow_celery_workers/config/proxy -o proxy

        server_name = $(curl -s http://whatismyip.akamai.com/)
        sed -i "s/SERVER-NAME/$server_name/g" proxy
        sed -i "s|127.0.0.1:8080|${var.frontend_instance_address}:8080|g" proxy
        sed -i "s|127.0.0.1:5555|${var.frontend_instance_address}:5555|g" proxy

        rm /etc/nginx/sites-enables/default
        /bin/cp -rf proxy /etc/nginx/sites-available/proxy
        ln -s /etc/nginx/sites-available/proxy /etc/nginx/sites-enables/proxy
        sudo nginx -s reload
      EOF
    }

    boot_disk {
      initialize_params {
        image = var.image
      }
    }

    network_interface {
      network = var.vpc_network_name
      access_config {}
    }
}