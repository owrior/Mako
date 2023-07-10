resource "google_compute_instance" "frontend_instance" {
  name = "frontend-instance"
  machine_type = var.machine.micro
  zone = var.zone.default
  allow_stopping_for_update = true

  metadata = {
    startup-script = <<-EOF
        #!/bin/bash
        
        sudo apt-get update -qqq
        sudo apt-get install docker-compose -qqq

        docker_id=$(
            sudo docker run \
            --net=host \
            -e AIRFLOW__CORE__EXECUTOR=CeleryExecutor \
            -e AIRFLOW__CELERY_RESULT_BACKEND=db+postgresql://airflow:airflow@localhost:5432/airflow \
            -e AIRFLOW__CORE__SQL_ALCHEMY_CONN=posgresql+psycopg2://airflow:airflow@localhost:5432/airflow \
            -e AIRFLOW__CELERY__BROKER_URL=redis://localhost:6379/1 \
            -d apache/airflow:2.0.1-python3.8 \
            airflow webserver -p 8080
        )

        sudo docker exec -d $docker_id \
            airflow celery flower \
                -p 5555 \
                -u /flower \
                -A ${var.flower.username}:${var.flower.password}
    EOF
  }

  boot_disk {
    initialize_params {
      image=var.image
    }
  }

  network_interface {
    network = var.vpc_network_name
    access_config {}
  }
}