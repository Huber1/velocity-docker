# Dockerized Velocity proxy

Based on the papermc repo by [Mark Tönsing](https://github.com/mtoensing/Docker-Minecraft-PaperMC-Server)\\
Usage is nearly identical


## Docker Compose

```yaml
services:
  proxy:
    image: ghcr.io/huber1/velocity-docker
    restart: always
    container_name: "mcproxy"
    environment:
      VELOCITY_FLAGS: ""
      PUID: 1000
      PGID: 1000
    volumes:
      - minecraftproxy:/data
    ports:
      - "25565:25565"
    # The following allow `docker attach minecraft` to work
    stdin_open: true
    tty: true

volumes:
  minecraftproxy:
```

## How do I update the container?

### On Terminal

```sh
docker compose down
docker compose pull 
docker compose up -d
```

Or just use https://containrrr.dev/watchtower/

## Run as another user

You can get the desired UID/GID (xxx) with the ID command (`id username`) then add the following to your docker run
command:

```sh
-e PUID=9001
-e PGID=9001
```

> [!NOTE]
> the permissions are set automatically.

## Run rootless

You can also run the container `rootless`. Just use the native user argument with your desired UID/GID:

```sh
--user=9001:9001
```

> [!IMPORTANT]  
> replace the IDs with your own.

> [!CAUTION]
> make sure the folder you mount has the correct permissions.

### Skip permission change step

If you have a big custom minecraft install (e.g. multiple plugins which generate files), changing ownership can take up
a
tremendous amount of time. You can skip this, by making sure that your files have the necessary permissions for the
UID/GID
that you passed using the environment variables above and then add the following variable:

```sh
-e SKIP_PERM_CHECK=true
```

## Docker Compose

If you prefer to use `docker compose`, use the following commands:

Start the server:

```shell
docker compose up
```

Stop the server:

```shell
docker compose stop
```

Issue server commands after attaching to the container:

```shell
docker attach mcproxy
# then you can type things like "list"
list
# which will show the current players online or
help
# to see all the commands available
```

## How to use the Makefile with Docker Compose

Additionally, a `Makefile` is provided to easily start, stop, and attach to the container.

```shell
make start     # equivalent to `docker compose up -d --build`
make stop      # equivalent to `docker compose stop --rmi all --remove-orphans`
make attach    # equivalent to `docker attach mcserver`
make help      # prints a help message
```

## Environment variables

### Memory

`MEMORYSIZE = 1G`

Not more than 70% of your RAM for your container. This is important. Because this is the RAM, your Minecraft Server will
use within the container WITHOUT the operating system.

But don't use this unless you really need this. Use runtime memory limits.

### Timezone

`TZ = Europe/Berlin`

Sets the timezone for the container. A list of valid values can be found on
Wikipedia: https://en.wikipedia.org/wiki/List_of_tz_database_time_zones

### Additional flags

`VELOCITY_FLAGS`

Optional: Sets the command-line flags for Velocity

`JAVAFLAGS`

Optional: Overrides the optimized java parameter configuration with your own. You can set your own Xms and Xmx values
this way.


