# Taskwarrior Server (taskd) Docker [![CircleCI](https://circleci.com/gh/ogarcia/docker-taskd.svg?style=svg)](https://circleci.com/gh/ogarcia/docker-taskd)

(c) 2015-2023 Óscar García Amor

Redistribution, modifications and pull requests are welcomed under the terms
of MIT license.

[Taskwarrior][1] is Free and Open Source Software that manages your TODO
list from your command line. It is flexible, fast, efficient, and
unobtrusive. It does its job then gets out of your way.

This docker packages **taskd**, Taskwarrior sync server, under [Alpine
Linux][2], a lightweight Linux distribution.

Visit [Docker Hub][3], [Quay][4] or [GitHub][5] to see all available tags.

[1]: https://www.taskwarrior.org/
[2]: https://alpinelinux.org/
[3]: https://hub.docker.com/r/connectical/taskd/
[4]: https://quay.io/repository/connectical/taskd/
[5]: https://github.com/orgs/connectical/packages/container/package/taskd

## Run

To run this container exposing taskd default port and making the data volume
permanent in `/srv/taskd`, simply run.

```sh
docker run -d \
  --name=taskd \
  -p 53589:53589 \
  -v /srv/taskd:/var/taskd \
  connectical/taskd
```

This makes a set of self signed certificates and minimal configuration to
run server.

## Environment variables

Certificate attributes can be customized using environment variables.

| Variable | Default value |
| --- | --- |
| `CERT_BITS` | 4096 |
| `CERT_EXPIRATION_DAYS` | 365 |
| `CERT_ORGANIZATION` | "Göteborg Bit Factory" |
| `CERT_CN` | localhost |
| `CERT_COUNTRY` | SE |
| `CERT_STATE` | "Västra Götaland" |
| `CERT_LOCALITY` | "Göteborg" |

Note that, by default, the generated certificates will have their `CN` set
to `localhost`.

If you have never run the container you can launch it as follows to set the
certificate values.
```
docker run -d \
  --name=taskd \
  -e CERT_BITS=4096 \
  -e CERT_EXPIRATION_DAYS=365 \
  -e CERT_ORGANIZATION="Göteborg Bit Factory" \
  -e CERT_CN=localhost \
  -e CERT_COUNTRY=SE \
  -e CERT_STATE="Västra Götaland" \
  -e CERT_LOCALITY="Göteborg" \
  -p 53589:53589 \
  -v /srv/taskd:/var/taskd \
  connectical/taskd
```

If you have the container running and you need to regenerate the
certificates or modify their parameters.

- Make sure that the container is running.
- Execute a shell in the running container.
  ```shell
  docker exec -t -i \
    <container-id> sh
  ```
- Go to `/var/taskd/pki` and delete all pem files, you should be left with
  only the generate scripts (`generate*`) and the `vars` file.
  ```shell
  rm *pem
  ```
- Run.
  ```shell
  export CERT_BITS=4096
  export CERT_EXPIRATION_DAYS=365
  export CERT_ORGANIZATION="Göteborg Bit Factory"
  export CERT_CN=localhost
  export CERT_COUNTRY=SE
  export CERT_STATE="Västra Götaland"
  export CERT_LOCALITY="Göteborg"
  ./generate
  ```

## Manual setup

The `run.sh` script that launch **taskd** server always look for config file
in data volume `/var/taskd`. If found it, simply run the server, but if
config file is absent `run.sh` will build a new default config and its
certificates.

If you make the data volume permanent you can access to its contents and
make modifications that you need. The significant files are.

* `config` taskd config itself.
* `log` directory of log.
* `org` taskd data.
* `pki` directory that contains certs and certs generation helpers.

You can do any changes to this, but remember that if you delete `config`
file, the `run.sh` script will rebuild everything.

Please refer to [Taskwarrior Docs][6] to know how do modifications, add
users, etc.

[6]: https://taskwarrior.org/docs/

## Shell run

In some cases, you could need to run `taskd` command. You can run this
docker in interactive mode, simply do.

```sh
docker run -ti --rm \
  -v /srv/taskd:/var/taskd \
  connectical/taskd /bin/sh
```

This mounts the permanent data volume `/srv/taskd` into **taskd** data
directory and gives you a interactive shell to work.

Please note that the `--rm` modifier destroy the docker after shell exit.
