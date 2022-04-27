# Docker Deployment

This directory contains an example deployment of Boundary using docker-compose
and Terraform. The lab environment is meant to accompany the Hashicorp Learn
[Boundary event logging
tutorial](https://learn.hashicorp.com/tutorials/boundary/event-logging).

In this example, Boundary is deployed using the
[hashicorp/boundary](https://hub.docker.com/r/hashicorp/boundary) Dockerhub
image. The Boundary service ports are forwarded to the host machine to mimic
being in a "public" network. 

This deployment includes the following containers:

- boundary controller
- boundary worker
- boundary db (postgres)
- elasticsearch
- kibana
- filebeat
- postgres target

Huge thanks to @tmessi for building the Kibana intergration components.

## Getting Started 

There is a helper script called `deploy` in this directory. You can use this
script to deploy, login, and cleanup.

Start the docker-compose deployment:

```bash
./deploy all
```

To login your Boundary CLI:

```bash
./deploy login
```

To stop all containers and start from scratch:

```bash
./deploy cleanup
```

Login to the UI:
  - Open browser to localhost:9200
  - Login Name: user1
  - Password: password
  - Auth method ID: find this in the UI when selecting the auth method or from TF output

```bash
$ boundary authenticate password -login-name user1 -password password -auth-method-id <get_from_console_or_tf>

Authentication information:
  Account ID:      apw_gAE1rrpnG2
  Auth Method ID:  ampw_Qrwp0l7UH4
  Expiration Time: Fri, 06 Nov 2020 07:17:01 PST
  Token:           at_NXiLK0izep_s14YkrMC6A4MajKyPekeqTTyqoFSg3cytC4cP8sssBRe5R8cXoerLkG7vmRYAY5q1Ksfew3JcxWSevNosoKarbkWABuBWPWZyQeUM1iEoFcz6uXLEyn1uVSKek7g9omERHrFs
```

## Audit logs and ELK
The boundary controller is configured to write out audit events to a log file,
`auditevents/controller.log`. The docker-compose.yml provides services for
collecting and shipping these logs to elasticsearch with kibana for
visualization of the audit events.

The `deploy` script changes the permissions on the `audtlogs/` directory:

```
$ chmod 777 ./auditlogs
```

Note: You might need to increase system limits for elasticsearch. See
[here](https://www.elastic.co/guide/en/elasticsearch/reference/current/vm-max-map-count.html)
for more details:

```
$ sudo sysctl -w vm.max_map_count=262144 
```

Note: You may need to change the permissions set on the audit log file produced
by boundary:

```
$ chmod 666 ./auditlogs/controller.log
```

Once the deployment is healthy, you can login to kibana using username `elastic`
and the password `elastic` at `http://localhost:5601` in a web browser. The
`$ELASTIC_PASSWORD`, `$KIBANA_PASSWORD`, and `$KIBANA_PORT` can be modified
within the `compose/.env` file.

To start creating visualizations for the data, create a data view:

- Navigate to http://localhost:5601/app/management/kibana/dataViews
- Click Create data view button
- Enter filebeat-* to the Name
- Confirm @timestamp is set as the Timestamp field
- Click Create data view
- Navigate to http://localhost:5601/app/discover#

If a dataView is not automatically discovered, check the permissions on
`auditlogs/` and `auditlogs/controller.log`.