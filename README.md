# Taskwarrior Server (taskd) Docker [![CircleCI](https://circleci.com/gh/ogarcia/docker-taskd.svg?style=svg)](https://circleci.com/gh/ogarcia/docker-taskd)

(c) 2015-2021 Óscar García Amor

Redistribution, modifications and pull requests are welcomed under the terms
of MIT license.

[Taskwarrior][1] is Free and Open Source Software that manages your TODO
list from your command line. It is flexible, fast, efficient, and
unobtrusive. It does its job then gets out of your way.

This docker packages **taskd**, Taskwarrior sync server, under [Alpine
Linux][2], a lightweight Linux distribution.

Visit [Docker Hub][3] or [Quay][4] to see all available tags.

[1]: https://www.taskwarrior.org/
[2]: https://alpinelinux.org/
[3]: https://hub.docker.com/r/connectical/taskd/
[4]: https://quay.io/repository/connectical/taskd/

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

Please note that the generated certificated will have their `CN` set to `localhost`. In order to modify the parameters used for the certificate generation:
- Delete everything in `/pki/` except the generate scripts (`generate*`) and the `vars` file.
- Edit the `vars` file.
- Run `docker exec -it <container-id> /var/taskd/pki/generate`.

## Manual setup

The `run.sh` script that launch **taskd** server always look for config file
in data volume `/var/taskd`. If found it, simply run the server, but if
config file is absent `run.sh` will build a new default config and its
certificates.

If you make the data volume permanent you'll can access to its contents and
make modifications that you need. The significant files are.

* `config` taskd config itself.
* `log` directory of log.
* `org` taskd data.
* `pki` directory that contains certs and certs generation helpers.

You can do any changes to this, but remember that if you delete `config`
file, the `run.sh` script will rebuild everything.

Please refer to [Taskwarrior Docs][5] to know how do modifications, add
users, etc.

[5]: https://taskwarrior.org/docs/

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
