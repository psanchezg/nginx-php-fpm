## Building from source
To build from source you need to clone the git repo and run docker build:
```
git clone https://github.com/psanchezg/nginx-php-fpm.git
cd nginx-php-fpm
```

The `build.sh` helper builds the supported PHP versions (8.2, 8.4 and 8.5)
for the native platform and loads the resulting images into Docker:
```
./build.sh
```

Build specific versions only:
```
./build.sh 8.4 8.5
```

Build multi-arch images and push them to Docker Hub:
```
PUSH=1 ./build.sh
```

The script accepts these environment variables:

| Variable | Default | Description |
|----|----|----|
| `IMAGE` | `psanchezg/nginx-php-fpm` | Image name |
| `VERSION` | `2.3.0` | Release version used in the image tags |
| `PLATFORMS` | `linux/amd64,linux/arm64` | Platforms used when `PUSH=1` |
| `PUSH` | `0` | Set to `1` to push instead of loading locally |

To build a single image manually, pass the PHP version as a build argument:
```
docker buildx build --load \
  --build-arg VER_PHP=8.5.12 \
  --build-arg VER_DOCKER_IMAGE=2.3.0-php8.5 \
  -t psanchezg/nginx-php-fpm:2.3.0-php8.5 .
```

The base image is selected from the official PHP Alpine tags using `VER_PHP`
and `DISTRO_VER` (for example `php:8.5.12-fpm-alpine3.24`). The nginx and Lua
dependency versions are defined at the top of the `Dockerfile` and can be
overridden with `--build-arg` as well.
