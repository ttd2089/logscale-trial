FROM ubuntu:24.04

COPY log-collector.deb /tmp/log-collector.deb

RUN dpkg -i /tmp/log-collector.deb \
    && usermod -a -G adm humio-log-collector

CMD humio-log-collector --cfg /etc/logscale-collector/config.yaml
