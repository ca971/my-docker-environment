# Usage

This environment uses [jwilder/nginx-proxy](https://github.com/jwilder/nginx-proxy) to handle dynamic routing traffic to your container.

## Setting up your Docker container

All your container needs is a `VIRTUAL_HOST` environment variable. `jwilder/nginx-proxy` will observe your container lifecycle events and dynamically generate a reverse proxy configuration.

## Example

Here is an example `docker-compose.yml` file

```yml
app:
    container_name: acme-app
    image: ubuntu:trusty
    volumes:
        - .:/var/www
        - ./logs/nginx:/var/log/nginx
    tty: true

php:
    container_name: acme-php
    image: php:5.6-fpm
    volumes_from:
        - app

nginx:
    container_name: acme-nginx
    image: nginx
    environment:
        - VIRTUAL_HOST=acme.docker.local
    links:
        - php
    volumes_from:
        - app
```

After you run `$ docker-compose up` you should be able to navigate to http://acme.docker.local/
