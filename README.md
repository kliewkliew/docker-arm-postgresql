# docker-arm-postgresql
Postgresql in Docker containers on ARM devices

## Precondition 
You have a Docker network named 'postgres' (docker network create postgres)

## New container
```
export DOCKER_DATA=/docker/data && \
export PSQL_VERSION=9.4 && \
docker run -it --rm \
    --name postgres -p 5432:5432 \
    --net=postgres \
    -v $DOCKER_DATA/postgres/data:/var/lib/postgresql/$PSQL_VERSION/main \
    -v $DOCKER_DATA/postgres/conf:/etc/postgresql/$PSQL_VERSION/main \
    -v $DOCKER_DATA/postgres/log:/var/log/postgresql/ postgres
```

Now modify /etc/postgresql/$PSQL_VERSION/main/pg_hba.conf with

```
#host all postgres 0.0.0.0/0 trust #only if your apps need to?
host all all 0.0.0.0/0 md5
```
and postgresql.conf with
`listen_addresses = '*'`
(or choose safer controls if your device is externally accessible - I'm using LAN)

Quit the container and rerun the same command. 


## Postcondition
You have a container accessible (to other containers on the same network, `--net=postgres`) by hostname 'postgres'. Data is persisted to `$DOCKER_DATA`. If you remove the postgres container and start a new container while `$DOCKER_DATA` already has data, the new container will use the old database.

## Notes
Docker has known problems with file permissions in mounted volumes. Normally the postgresql service won't start unless the config and data owner are the same as the configured cluster owner (not the case when mounting volumes). I got around that by creating the cluster with the host's root user `-u 0` (which differs from the container's root user).
