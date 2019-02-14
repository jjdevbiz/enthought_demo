# Enthought Demo

> https://sourcegraph.hodly.group

## Description:

This demo builds an ec2 instance of Sourcegraph (https://sourcegraph.com/welcome) which will use external postgresql (RDS) and redis (elasticache) behind a custom Nginx web server (Docker container) making use of perfect forward secrecy and LetsEncrypt SSL for an A grade from SSLLabs (https://www.ssllabs.com/ssltest/analyze.html?d=sourcegraph.hodly.group). The RDS instance utilizes an encrypted volume.

The Sourcegraph instance contains all of Enthoughts public repositories (135 total) retrieved via GitHub api (https://developer.github.com/v3/repos/#list-user-repositories) with curl:

```
for i in {1..5}; do
curl -s --header 'Accept: application/json' "https://api.github.com/users/enthought/repos?per_page=100&page=$i" | jq '.[] | . | select(.private==false) | .full_name'
done
```

* Nginx configuration can be viewed via nginx.conf and default.conf located:

> dockerfiles/nginx-proxy/nginx.conf

> dockerfiles/nginx-proxy/default.conf

## Launch

The entire build process is automated upon instance launch after applying terraform state via the terraform/ec2.tf userdata script (terraform/userdata/sourcegraph.sh) and inline file placement on the instance (/tmp/dotenv) including installing the most recent version of docker, building the Nginx container, pulling the sourcegraph:3.0 container, daemonizing the processes (which restart upon failuture and at boot) with docker run --restart=unless-stopped flag, and installing letsencrypt TLS certificates inside the Nginx container (dockerfiles/nginx-proxy/entrypoint.sh). Terraform handles applying route53 DNS A record to the ec2 instance public IP assigned at launch, applying security groups for ports 22 (ssh), 80 (web), 443 (ssl/tls web), 5432 (postgresql), 6379 (redis), 2633 (sourcegraph-mgmt) within the default VPC. All administration is handled via Makefile. All runtime and build variables are sourced from dotenv.

Note: Manual account steps included directing my dummy domain (hodly.group) Nameservers to AWS NS anchor and creating the zone_id within the route53 management console (stored in dotenv). I was not given a domain for use with this assignment but I have several spares so no worries :)

* Populate envfile.template with values for deployment:

> $HOME/.enthought_demo_environment

```
aws_default_region=
demo_admin_key=
demo_admin_privkey=
demo_admin_pubkey=
AWS_DEMO_KEY=
AWS_DEMO_SECRET=
rds_username=
rds_password=
hosted_zone_id=
secretHash=
dummy_domain=
defaultSubnet=
```

* Test the configuration:

> enthought_demo/terraform$ make plan

* Apply:

> enthought_demo/terraform$ make apply

* Populating Enthought public repositories within Sourcegraph and adding 2 user emails were done via the dashboard according to the documentation (https://docs.sourcegraph.com/), see NOTES.md for scratchpad notes.
