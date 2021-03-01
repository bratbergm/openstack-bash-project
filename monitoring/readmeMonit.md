**Monitoring**

- Prometheus
- Node exporter
- cAdvisor
- Blackbox exporter
- Grafana



TL;DR

Overvåkning av infrastrukteren (CPU-, minne- bruk, nettverkstrafikk) og bookface nettsiden (opp/ned), med varsling til Discord. 



**Prometheus** 

Brukes til overvåkning og varsling. Får data fra node exporter, cAdvisor og Blackbox exporter. Prometheus har eget interface med grafer, men i denne koden brukes grafana. Er også en film av Ridley Scott.



**Node Exporter**

Henter ut metrics fra maskiner. Kjøres på alle de vm'ene som skal overvåkes (*klienter*). Leses av Prometheus som kjøres på en sentral vm (*server*). 

*På klienter*

```bash
# (Finn siste versjon: https://prometheus.io/download/#node_exporter)
wget https://github.com/prometheus/node_exporter/releases/download/v1.1.0/node_exporter-1.1.0.linux-amd64.tar.gz
tar xvfz node_exporter-1.1.0.linux-amd64.tar.gz
cd node_exporter-1.1.0.linux-amd64
./node_exporter&
# (&: kjør i bakgrunn)
# Sjekk om fungerer:
http://localhost:9100/metrics
# Firewall: allow port 9100 (hvis UFW er installert)
sudo ufw allow from <network_ip> to any port 9100
```

*På Server*

*prometheus.yml*

```yaml
# Legg til klientene i scrape config, targets, med port 9100
scrape_configs:
  - job_name: 'nodeexporter'
    scrape_interval: 5s
    static_configs:
      - targets: ['192.168.1.6:9100', '192.168.1.7:9100'] 
```



**cAdvisor**

(*Container Advisor*) Henter ut metrics fra kontainere. 



**Blackbox exporter**

Prober nettsider. Kan sjekke om en nettside er oppe. Kjøres på *server*. De nettsidene man vil probe legges til i:

*blackbox_targets.yml*

```yaml
- targets:
  - https://www.vg.no/
  - http://10.212.139.132/
```

Targets kan endres on-the-fly

Sjekk om netsiden er oppe:

- Returnerer 1 om svar og 0 om ikke svar

- ```bash
  probe_success{instance="http://10.212.139.132/",job="blackbox"}
  ```

Indikasjon på om databasen er oppe:

- Vi setter skille på 1000. Kommer det under, går det alert.

- ```bash
  probe_http_uncompressed_body_length{instance="http://10.212.139.132/",job="blackbox"}
  ```



**Grafana**

- Grafer og varsling. Får data fra Prometheus og lager fancy grafer og sånt :drooling_face:

- Provisioning

  - Dashboards ligger i koden

  - Datasource ligger i koden

  - Det er IKKE provisioning for alerts i koden. Vi bruker varsling i Discord. Det er lite dokumentasjon om provisioning for alerts til Discord, så dette setter vi foreløpig opp manuelt:

    I Grafana: 

    Alert rules -> New Channel -> Type: *Discord*, Webook URL: hent fra discord server

    Edit en graf -> Alert ->  Sett parametre -> Send to: *Discord* 

- For å redigere dashbordet:

  - Ta ut JSON koden og lag nytt dashboard:
    - Dashboard settings (øverst på siden)
    - JSON model (copy)
    - Create -> import (paste)
    - Denne kan nå endres og lagres
      - [ ]  Husk å trykk **Save** for at alerts skal tre i kraft



Dashbordet vårt er basert på:

- https://grafana.com/grafana/dashboards/11757 
- https://grafana.com/grafana/dashboards/7587       







```bash

   mmm         #                     mmmm                   mm  m    m
 m"   " m   m  #mmm    mmm    m mm  #"   "  mmm    mmm     m"#  #    #
 #      "m m"  #" "#  #"  #   #"  " "#mmm  #"  #  #"  "   #" #  #    #
 #       #m#   #   #  #""""   #         "# #""""  #      #mmm#m #    #
  "mmm"  "#    ##m#"  "#mm"   #     "mmm#" "#mm"  "#mm"      #  "mmmm"
         m"
        ""
```

