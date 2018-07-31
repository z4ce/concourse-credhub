# Concourse + Credhub

Opinionated [operations files](https://bosh.io/docs/cli-ops-files/) for
deploying Concourse with Credhub.

These files collocate the Credhub and UAA jobs with Concourse's ATC.
This configuration is documented in the
[Control Plane reference architectures](https://docs.pivotal.io/pivotalcf/2-2/refarch/control.html)
and is depicted in the following diagram:

![Credhub](https://docs.pivotal.io/pivotalcf/2-2/refarch/images/concourse-bosh-jobs.png)

## Deployment

This repo contains operations files that are meant to be used in conjunction with
the manifests and operations files located at
https://github.com/concourse/concourse-bosh-deployment

## BBL Load Balancer

By placing the Credhub and UAA servers on the same instances as Concourse's ATC,
we require the load balancer fronting the ATC to be extended to allow for both
Credhub (port 8844) and UAA (port 8443) traffic.

If you are using [`bbl`](https://github.com/cloudfoundry/bosh-bootloader) to
create this load balancer, you can leverage the terraform provided in the
`bbl-terraform` directory to extend this load balancer to support
these additional ports.

This is referred to as a [_plan patch_](https://github.com/cloudfoundry/bosh-bootloader/blob/master/plan-patches/README.md).

The general flow is:

```
$ bbl plan --lb-type=concourse
$ cp bbl-terraform/<IAAS>/*.tf $BBL_STATE_DIRECTORY/terraform/
$ bbl up
```

## Backup/Restore via BBR

If you wish to use [`bbr`](https://github.com/cloudfoundry-incubator/bosh-backup-and-restore)
to backup and restore the deployment, you'll need to add some extra operations files to your
deployment:

- enable-db-backups.yml: Include the backup and restore SDK release and add backup-restorer job
- backup-atc-db.yml: Backup Concourse's ATC database (pipelines, build logs, etc)
- backup-uaa-db.yml: Backup the UAA database (users, clients, secrets, etc)
- backup-credhub-db.yml: Backup the Credhub database (Credhub secrets)

## Connecting to your new Credhub

The client secret for connecting to the Concourse Credhub is stored in the BOSH
director's Credhub.  This repo includes a `target-concourse-credhub.sh` script
that you can source in order to target the Concourse Credhub.

```
$ CONCOURSE_URL=https://concourse.example.com source target-concourse-credhub.sh
$ credhub find
```
