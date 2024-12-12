![docker hub](https://img.shields.io/docker/pulls/psanchezg/nginx-php-fpm.svg?style=flat-square)
![docker hub](https://img.shields.io/docker/stars/psanchezg/nginx-php-fpm.svg?style=flat-square)

## Overview
This is a Dockerfile/image to build a container for nginx and php-fpm, with the ability to pull website code from git when the container is created, as well as allowing the container to push and pull changes to the code to and from git. The container also has the ability to update templated files with variables passed to docker in order to update your code and settings. There is support for lets encrypt SSL configurations, custom nginx configs, core nginx/PHP variable overrides for running preferences, X-Forwarded-For headers and UID mapping for local volume support.

If you have improvements or suggestions please open an issue or pull request on the GitHub project page.

### Versioning
| Docker Tag | Git Release | Nginx Version | PHP Version | LUA Version | Alpine Version | Java Version | Platforms |
|-----|-------|-----|--------|--------|--------|--------|--------|
| 1.4.0 | main | 1.24.0 | 5.6.40 | - | 3.8 | - | amd64 |
| 1.5.8 | main | 1.22.1 | 7.2.34 | - | 3.12 | - | amd64 |
| 1.5.9 | main | 1.26.2 | 7.2.34 | 5.1 | 3.12 | - | amd64, arm64 |
| 1.8.1 | main | 1.23.2 | 7.4.33 | - | 3.16 | 11 | amd64 |
| 1.8.3 | main | 1.26.2 | 7.4.33 | 5.4.4 | 3.16 | 11 | amd64, arm64 |
| 2.1.6 | main | 1.26.2 | 8.1.31 | 5.4.6 | 3.20 | - | amd64, arm64 |

For other tags please see: [versioning](https://github.com/psanchezg/nginx-php-fpm/tree/main/docs/versioning.md)

### Links
- [https://github.com/psanchezg/nginx-php-fpm](https://github.com/psanchezg/nginx-php-fpm)
- [https://gitlab.com/ric_harvey/nginx-php-fpm](https://gitlab.com/ric_harvey/nginx-php-fpm)
- [https://registry.hub.docker.com/u/psanchezg/nginx-php-fpm/](https://registry.hub.docker.com/u/psanchezg/nginx-php-fpm/)

## Quick Start

To build image (tested from Mac M2):
```
DOCKER_DEFAULT_PLATFORM=linux/amd64 docker build -t psanchezg/nginx-php-fpm:1.4.0 -f Dockerfile-5.6 .
docker buildx build --platform=linux/amd64,linux/arm64 -t psanchezg/nginx-php-fpm:1.5.9 -f Dockerfile-7.2 .
docker buildx build --platform=linux/amd64,linux/arm64 --build-arg VER_LUA=5.4 --build-arg VER_PHP=7.4 --build-arg DISTRO_VER=3.16 --build-arg VER_DOCKER_IMAGE=1.8.3 -t psanchezg/nginx-php-fpm:1.8.3 .
docker buildx build --platform=linux/amd64,linux/arm64 --build-arg VER_LUA=5.4 --build-arg VER_PHP=8.1 --build-arg DISTRO_VER=3.20 --build-arg VER_DOCKER_IMAGE=2.1.6 -t psanchezg/nginx-php-fpm:2.1.6 .
```

To pull from docker hub:
```
docker pull psanchezg/nginx-php-fpm:1.4.0
docker pull psanchezg/nginx-php-fpm:1.5.9
docker pull psanchezg/nginx-php-fpm:1.8.3
docker pull psanchezg/nginx-php-fpm:2.1.6
```
### Running
To simply run the container:
```
docker run -d psanchezg/nginx-php-fpm:1.4.0
docker run -d psanchezg/nginx-php-fpm:1.5.9
docker run -d psanchezg/nginx-php-fpm:1.8.3
docker run -d psanchezg/nginx-php-fpm:2.1.6
```
To dynamically pull code from git when starting:
```
docker run -d -e 'GIT_EMAIL=email_address' -e 'GIT_NAME=full_name' -e 'GIT_USERNAME=git_username' -e 'GIT_REPO=github.com/project' -e 'GIT_PERSONAL_TOKEN=<long_token_string_here>' psanchezg/nginx-php-fpm:1.5.9
```

You can then browse to ```http://<DOCKER_HOST>``` to view the default install files. To find your ```DOCKER_HOST``` use the ```docker inspect``` to get the IP address (normally 172.17.0.2)

For more detailed examples and explanations please refer to the documentation.
## Documentation

- [Building from source](https://github.com/psanchezg/nginx-php-fpm/tree/main/docs/building.md)
- [Versioning](https://github.com/psanchezg/nginx-php-fpm/tree/main/docs/versioning.md)
- [Config Flags](https://github.com/psanchezg/nginx-php-fpm/tree/main/docs/config_flags.md)
- [Git Auth](https://github.com/psanchezg/nginx-php-fpm/tree/main/docs/git_auth.md)
  - [Personal Access token](https://github.com/psanchezg/nginx-php-fpm/tree/main/docs/git_auth.md#personal-access-token)
  - [SSH Keys](https://github.com/psanchezg/nginx-php-fpm/tree/main/docs/git_auth.md#ssh-keys)
- [Git Commands](https://github.com/psanchezg/nginx-php-fpm/tree/main/docs/git_commands.md)
 - [Push](https://github.com/psanchezg/nginx-php-fpm/tree/main/docs/git_commands.md#push-code-to-git)
 - [Pull](https://github.com/psanchezg/nginx-php-fpm/tree/main/docs/git_commands.md#pull-code-from-git-refresh)
- [Repository layout / webroot](https://github.com/psanchezg/nginx-php-fpm/tree/main/docs/repo_layout.md)
 - [webroot](https://github.com/psanchezg/nginx-php-fpm/tree/main/docs/repo_layout.md#src--webroot)
- [User / Group Identifiers](https://github.com/psanchezg/nginx-php-fpm/tree/main/docs/UID_GID_Mapping.md)
- [Custom Nginx Config files](https://github.com/psanchezg/nginx-php-fpm/tree/main/docs/nginx_configs.md)
 - [REAL IP / X-Forwarded-For Headers](https://github.com/psanchezg/nginx-php-fpm/tree/main/docs/nginx_configs.md#real-ip--x-forwarded-for-headers)
- [Scripting and Templating](https://github.com/psanchezg/nginx-php-fpm/tree/main/docs/scripting_templating.md)
 - [Environment Variables](https://github.com/psanchezg/nginx-php-fpm/tree/main/docs/scripting_templating.md#using-environment-variables--templating)
- [Lets Encrypt Support](https://github.com/psanchezg/nginx-php-fpm/tree/main/docs/lets_encrypt.md)
 - [Setup](https://github.com/psanchezg/nginx-php-fpm/tree/main/docs/lets_encrypt.md#setup)
 - [Renewal](https://github.com/psanchezg/nginx-php-fpm/tree/main/docs/lets_encrypt.md#renewal)
- [PHP Modules](https://github.com/psanchezg/nginx-php-fpm/tree/main/docs/php_modules.md)
- [Xdebug](https://github.com/psanchezg/nginx-php-fpm/tree/main/docs/xdebug.md)
- [Logging and Errors](https://github.com/psanchezg/nginx-php-fpm/tree/main/docs/logs.md)

## Guides
- [Running in Kubernetes](https://github.com/psanchezg/nginx-php-fpm/tree/main/docs/guides/kubernetes.md)
- [Using Docker Compose](https://github.com/psanchezg/nginx-php-fpm/tree/main/docs/guides/docker_compose.md)
