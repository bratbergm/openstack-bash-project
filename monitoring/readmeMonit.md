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





sjekk ut: https://community.grafana.com/t/grafana-v7-1-5-alerting-to-discord/36524





- Grafana Dashboards
  - https://grafana.com/grafana/dashboards/11074  (mye)
  - https://grafana.com/grafana/dashboards/11756 kolone for hver server 
  - https://grafana.com/grafana/dashboards/11757 ^ Enklere versjon    <---  denne
  - https://grafana.com/grafana/dashboards/7587      HTTP probe  <----- og denne
  - https://grafana.com/grafana/dashboards/179 Containere og host 
  - HaProxy (ikke testa)
  - https://grafana.com/grafana/dashboards/10283 - data fra flere servere - fin



**BlackBox** 

for HTTP probing: https://github.com/prometheus/blackbox_exporter

blackbox.yml

```yaml
modules:
  http_2xx:
    prober: http
    http:
      preferred_ip_protocol: "ip4"
```

```bash
docker run --rm -d -p 9115:9115 --name blackbox_exporter -v `pwd`:/config prom/blackbox-exporter:master --config.file=/config/blackbox.yml
```





**To do**



Sett sammen de to













