# Docker Deployment

This directory contains an example deployment of Boundary using docker-compose and Terraform. The lab environment is meant to accompany the Hashicorp Learn [Boundary event logging tutorial](https://learn.hashicorp.com/tutorials/boundary/event-logging).

In this example, Boundary is deployed using the [hashicorp/boundary](https://hub.docker.com/r/hashicorp/boundary) Dockerhub image. The Boundary service ports are forwarded to the host machine to mimic being in a "public" network. 

## Getting Started 

There is a helper script called `deploy` in this directory. You can use this script to deploy, login, and cleanup.

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