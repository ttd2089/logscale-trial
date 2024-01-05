# LogScale Trial

This repository contains a Docker Compose environment that runs an HTTP echo server with Apache as a reverse proxy and ships Apache's logs to LogScale.


## Getting Started


1. Get LogScale

You'll need to have a LogScale instance to send logs to. There are managed and self hosted options.

- [Cloud Community](https://cloud.community.humio.com/)
- [Cloud](https://cloud.humio.com/)
- [Self Hosted](https://library.humio.com/falcon-logscale-self-hosted-1.112/falcon-logscale-docs.html)


2. Configure A Repository And Ingest Token

[Create a repository](https://library.humio.com/data-analysis/repositories-create.html) in your log scale instance and [create an ingest token](https://library.humio.com/falcon-logscale-cloud/ingesting-data-tokens.html) (or use the default token) for the collector to use.


3. Get The Collector Installer

Follow the directions [here](https://library.humio.com/falcon-logscale-collector/log-shippers-log-collector-install-linux.html) to download the installer for the Log Collector to the root of the repository, then rename the package to `log-collector.deb`.


4. Set Up Your Environment

The Docker Compose environment passes the LogScale URL and Ingest Token into the collectors environment from the host environment.

Set `LOGSCALE_URL` to the URL for your LogScale intsance, and set `LOGSCALE_INGEST_TOKEN` to the Ingest Token for your repository. See the [`sinks` configuration docs](https://library.humio.com/falcon-logscale-collector/log-shippers-log-collector-config-common.html#log-shippers-log-collector-config-common-sinks) for more details.


5. Bring Up The Compose Environment

`docker compose up -d`


6. Send Requests To The Echo Server

The echo server's proxy is listening on `localhost:8080`. Send requests to the server via the proxy to generate access logs that will be shipped to LogScale. Use the [generate-requests.sh](./generate-requests.sh) script to generate batches of requests and logs.
