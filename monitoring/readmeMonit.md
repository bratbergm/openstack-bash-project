**Monitoring**

- Prometheus
- Node exporter
- cAdvisor
- Blackbox exporter
- Grafana



*Node Exporter* 

På klienter

```bash
# (Finn siste versjon: https://prometheus.io/download/#node_exporter)
wget https://github.com/prometheus/node_exporter/releases/download/v1.1.0/node_exporter-1.1.0.linux-amd64.tar.gz
tar xvfz node_exporter-1.1.0.linux-amd64.tar.gz
cd node_exporter-1.1.0.linux-amd64
./node_exporter&
# (&: kjør i bakgrunn)
# Sjekk om fungerer:
http://localhost:9100/metrics
# Firewall: allow port 9100
sudo ufw allow from <network_ip> to any port 9100
```

På Server

*prometheus.yml*

```yaml
# Legg til klientene i scrape config, targets
scrape_configs:
  - job_name: 'nodeexporter'
    scrape_interval: 5s
    static_configs:
      - targets: ['192.168.1.6:9100', '192.168.1.7:9100'] 
     
```

*blackbox_targets.yml*

```yaml
- targets:
  - https://www.vg.no/
  - http://192.168.1.7:49155/
```

- Targets kan endres on-the-fly

```bash
# I /monitor mappa
docker-copose up -d
```



*Grafana*

```bash
<ip>:9000
# Data Source: Prometheus
http://prometheus:9090
```



- Grafana Dashboards
  - https://grafana.com/grafana/dashboards/11757 
  - https://grafana.com/grafana/dashboards/7587      HTTP probe 











