#!/bin/bash
sudo mkdir -p /usr/local/lib/docker/cli-plugins
sudo curl -SL https://github.com/docker/compose/releases/download/v2.14.0/docker-compose-linux-x86_64 -o /usr/local/lib/docker/cli-plugins/docker-compose 
sudo chmod +x /usr/local/lib/docker/cli-plugins/docker-compose
mkdir -p /home/ec2-user/prometheus
cat <<EOF > /home/ec2-user/prometheus/prometheus.yml
global:
  scrape_interval: 60s
  external_labels:
    monitor: 'pokedex-monitor'
scrape_configs:
  - job_name: 'prometheus'
    static_configs:
    - targets: ['localhost:9090']
  - job_name: 'ec2_aws_node_exporter'
    ec2_sd_configs:
      - region: ${region}
        profile: ${role_arn}
        port: 9100
        filters:
        - name: tag:aws:autoscaling:groupName
          values:
          - ${asg_name}
  - job_name: 'ecs_aws_cadvisor_exporter'
    ec2_sd_configs:
      - region: ${region}
        profile: ${role_arn}
        port: 9200
        filters:
        - name: tag:aws:autoscaling:groupName
          values:
          - ${asg_name}
EOF
cat <<EOF > /home/ec2-user/prometheus/docker-compose.yml
services:
  prometheus:
    image: prom/prometheus:v2.40.5
    volumes:
      - /home/ec2-user/prometheus/prometheus.yml:/etc/prometheus/prometheus.yml
    ports:
      - "9090:9090"
    restart: always

EOF
docker compose -f /home/ec2-user/prometheus/docker-compose.yml up -d
