#!/bin/bash

# local path to https://github.com/concourse/concourse-bosh-deployment
CONCOURSE_BOSH_DEPLOYMENT=~/concourse-bosh-deployment

bosh deploy -d concourse $CONCOURSE_BOSH_DEPLOYMENT/cluster/concourse.yml \
   -l $CONCOURSE_BOSH_DEPLOYMENT/versions.yml \
   -l versions.yml \
   -v deployment_name=concourse \
   -v network_name=default \
   -v web_network_name=default \
   -v web_network_vm_extension=lb \
   -v external_host=concourse.example.com \
   -v external_url="https://concourse.example.com" \
   -v web_vm_type=large \
   -v db_vm_type=large \
   -v worker_vm_type=extra-large \
   -v db_persistent_disk_type=100GB \
   -o $CONCOURSE_BOSH_DEPLOYMENT/cluster/operations/basic-auth.yml \
   -o $CONCOURSE_BOSH_DEPLOYMENT/cluster/operations/privileged-http.yml \
   -o $CONCOURSE_BOSH_DEPLOYMENT/cluster/operations/privileged-https.yml \
   -o $CONCOURSE_BOSH_DEPLOYMENT/cluster/operations/tls.yml \
   -o $CONCOURSE_BOSH_DEPLOYMENT/cluster/operations/tls-vars.yml \
   -o $CONCOURSE_BOSH_DEPLOYMENT/cluster/operations/web-network-extension.yml \
   -o operations/add-credhub-uaa-to-web.yml \
   -o operations/enable-db-backups.yml \
   -o operations/backup-atc-db.yml \
   -o operations/backup-uaa-db.yml \
   -o operations/backup-credhub-db.yml
