# Wordpress Docker Setup

This repository is intended to quickly set up a WordPress development environment using Docker.

## Prerequisites

In order for this project to run you need Docker and Docker Compose installed on your system.

- [Docker Installation Instructions](https://docs.docker.com/engine/install/)
- [Docker Compose Installtion Instructions](https://docs.docker.com/compose/install/)

If you are running a non-linux environment you will also need Docker Desktop.
This will take care of Docker and Docker Compose as well.

- [Docker Desktop Guide (Windows)](https://docs.docker.com/desktop/install/windows-install/)
- [Docker Desktop Guide (Mac)](https://docs.docker.com/desktop/install/mac-install/)

## Running the Repository

Once you have Docker installed, clone this repo and navigate to the
`wordpress-docker-setup` folder in your terminal.

Then start the containers using Docker Compose.

```shell
cd wordpress-docker-setup
docker-compose up -d
```

This will spin up a WordPress instance available at http://localhost:8080 by default.
The port can be overridden via the `WORDPRESS_PORT` environment variable.

### Container Structure

The `docker-compose.yml` file defines three services.

#### wordpress

This runs a PHP-FPM container specifically configured for WordPress.
Currently, it is running `wordpress:php8.2-fpm`. This can be changed by setting the `PHP_VERSION` prior to build.
See _environment variables_ section below. This service is built using the `Dockerfile` at the project root.
This file is just a light wrapper around the official image which adds optional support for Xdebug.

A local volume is created by this service, `./wordpress:/var/www/html`.
The first time this service is run, it will create a `wordpress` folder in the project root.
This folder will contain the WordPress files. This project's `.gitignore` file does not commit this folder.
To put your WordPress project under version control,
you will either need to remove `wordpress/` from the `.gitignore` file,
or initialize a git repo directly in the `wordpress` folder after it's been created.

#### nginx

This just runs the latest version of Nginx. The server is configured via `nginx/localhost.conf`.
This connects the Nginx server to the WordPress FPM.

#### mariadb

This pulls the latest MariaDB image and configures WordPress to use it. A Docker volume is created named `wp-data`.
This will persist your data.

### Xdebug

This repo makes it very easy to configure Xdebug for WordPress. A few environment variables need to be set
and your IDE needs to be configured to work with Xdebug over Docker.

Set the following environment variables prior to build to install Xdebug in the Docker image.

- **WITH_XDEBUG**: Set this to `true`
- **HOST_IP_ADDRESS**: Set this to the internal IP address of your development machine, e.g., 192.168.1.100
- **HOST_IDE_KEY**: Set this to the Xdebug key your IDE uses, e.g. `VSCODE`. Default is `PHPSTORM`.
- **XDEBUG_PORT**: If you have a port conflict with the default Xdebug port of 9003, you can update this

Configuring an IDE to work with Xdebug over Docker can be tricky. Here are some helpful articles.

- [Xdebug in PHPStorm with Docker](https://dev.to/jackmiras/xdebug-in-phpstorm-with-docker-2al8)
- [Xdebug in VSCode with Docker](https://dev.to/jackmiras/xdebug-in-vscode-with-docker-379l)

### Environment Variables

This repo comes with a `.env.sample` file with all configuration options.
Copy this to `.env` file in the project root and update for your needs.

| Variable          | Description                                         | Default   |
|-------------------|-----------------------------------------------------|-----------|
| `PHP_VERSION`     | Determines the WordPress FPM image version to use.  | 8.2       |
| `WORDPRESS_PORT`  | Port to access WordPress over localhost.            | 8080      |
| `WITH_XDEBUG`     | Is Xdebug enabled in WordPress image?               | false     |
| `HOST_IP_ADDRESS` | IP Address Xdebug will attempt to communicate with. | 127.0.0.1 |
| `HOST_IDE_KEY`    | IDE Key Xdebug uses for connections.                | PHPSTORM  |
| `XDEBUG_PORT`     | Local port Xdebug connects through.                 | 9003      |