# docker-greenplum

[![Actions Status](https://github.com/woblerr/docker-greenplum/workflows/build/badge.svg)](https://github.com/woblerr/docker-greenplum/actions)

This project provides a Docker image for running Greenplum Database (GPDB) in containers. It supports both single-node and multi-node deployments. The image can be use for development, testing, and learning purposes.

The Greenplum in docker provides the following features:
- single-node deployment;
- master and segments deployment;
- support for segment mirroring;
- gpperfmon;
- diskquota;
- gpbackup/gprestore;
- gpbackup-s3-plugin;
- gpbackman;
- PXF (Platform Extension Framework).

Environment variables supported by this image:

* `TZ` - container's time zone, default `Etc/UTC`;
* `GREENPLUM_USER` - non-root user name for execution of the command, default `gpadmin`;
* `GREENPLUM_UID` - UID of `${GREENPLUM_USER}` user, default `1001`;
* `GREENPLUM_GROUP` - group name of `${GREENPLUM_USER}` user, default `gpadmin`;
* `GREENPLUM_GID` - GID of `${GREENPLUM_USER}` user, default `1001`;
* `GREENPLUM_DEPLOYMENT` - Greenplum deployment type, default `singlenode`, available values: `singlenode`, `master`, `segment`;
* `GREENPLUM_DATA_DIRECTORY` - Greenplum data directory location, default `/data`;
* `GREENPLUM_SEG_PREFIX` - Greenplum segment prefix, default `gpseg`;
* `GREENPLUM_DATABASE_NAME` - Greenplum database name, default `demo`, this database will be created during the initialization;
* `GREENPLUM_GPPERFMON_ENABLE` - enable gpperfmon, default `false`;
* `GREENPLUM_DISKQUOTA_ENABLE` - enable diskquota, default `false`;
* `GREENPLUM_PXF_ENABLE` - enable PXF, default `false`;

Required environment variables:
* `GREENPLUM_PASSWORD` - password for `${GREENPLUM_USER}` user, **required**;
* `GREENPLUM_GPMON_PASSWORD` - password for `gpmon` user, **required** when `GREENPLUM_GPPERFMON_ENABLE` is `true`;

## Pull
Change `tag` to to the version you need.

* Docker Hub:

```bash
docker pull woblerr/greenplum:tag
```

* GitHub Registry:

```bash
docker pull ghcr.io/woblerr/greenplum:tag
```

## Run

You will need to mount the necessary directories or files inside the container (or use this image to build your own on top of it).

### Simple

```bash
docker run -p 5432:5432 -e GREENPLUM_PASSWORD=gparray -d greenplum:6.27.1
```

Connect to Greenplum:

```bash
psql -h localhost -p 5432 -U gpadmin demo
```

### Docker Secrets
As an alternative to passing sensitive information via environment variables, `_FILE` may be appended to `GREENPLUM_PASSWORD` and `GREENPLUM_GPMON_PASSWORD` environment variables. In particular, this can be used to load passwords from Docker secrets stored in `/run/secrets/<secret_name>` files. 

For example:
```bash
docker run -p 5432:5432 -e GREENPLUM_PASSWORD_FILE=/run/secrets/gpdb_password -d greenplum:6.27.1
```

### Docker Compose
Prepare password files (**set your own passwords**):
```bash
echo "gparray" > docker-compose/secrets/gpdb_password
echo "changeme" > docker-compose/secrets/gpmon_password
```

Run  cluster with 1 master and 2 segments without mirroring:
```bash
docker compose -f ./docker-compose/docker-compose.no-mirroring.yaml up -d
```

Run cluster with persistent storage:
```bash
docker compose -f ./docker-compose/docker-compose.no_mirrors_persistent.yaml up -d
```

Run cluster with 1 master and 2 segments with mirroring:
```bash
docker compose -f ./docker-compose/docker-compose.mirroring.yaml up -d
```

## Build

```bash
docker buildx build --platform linux/amd64 -f docker/ubuntu/6/Dockerfile -t greenplum:6.27.1 .
```