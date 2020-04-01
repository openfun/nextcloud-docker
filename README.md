# Nextcloud docker image

This repository contains the `Dockerfile` to build a [Nextcloud](https://nextcloud.com/) image.

## Disclaimer

:warning: **This image is crafted to work on OpenShift and deployed using [Arnold](https://github.com/openfun/arnold)**

### What is specific to this image ?

This image is built from official [Nextcloud image](https://github.com/nextcloud/docker), 
it uses only `php-fpm` and must be used with a reverse proxy like [nginx](https://nginx.org).

The user running the image is an un-privileged user, it is not `www-data` like in original image.

The volume created in nextcloud (`/var/www/html`) image is not used. Nextcloud is installed in  the `/app` directory
and no volume is used anymore.

This image is configured to use only postgresql.

The original entrypoint is replaced by our own. It runs the `occ upgrade` command if the config file (`/app/config/config.php`)
exists.

The `install.sh` script should be run in a dedicated job. To be sure to not run it on every deployment, a file is created in `/tmp/nextcloud/`.
This repository should be shared through a volume mounted in this job.


## How to build this image

To build a new Nextcloud image you have to pick an existing tag made in the official [Nextcloud image](https://github.com/nextcloud/docker)
and then use it using the following docker command (here with the tag `18.0.3-fpm`):

```bash
$ export NEXTCLOUD_VERSION=18.0.3-fpm
$ docker build \
    --build-arg NEXTCLOUD_VERSION="${NEXTCLOUD_VERSION}" \
    -t fundocker/nextcloud:${NEXTCLOUD_VERSION} .
```

## How to use the CI

The CI configured in this repository will test if the image can be built
successfully for a particular release, but it also pushes images to docker hub
when this repository is tagged.

Here are the steps to follow to publish a new image:

- Edit the `.circleci/releases.sh` file and update the tag version corresponding
  to the image you want to publish.
- Commit your changes, submit a pull request and once merged into master you
  will be able to tag a new version.
