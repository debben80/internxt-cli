[![GitHub package.json prod dependency version](https://img.shields.io/github/package-json/dependency-version/debben80/internxt-cli/%40internxt%2Fcli?filename=%2Fapp%2Fpackage.json&style=flat-square)](https://github.com/internxt/cli)
[![Release](https://img.shields.io/github/v/release/debben80/internxt-cli?style=flat-square)](https://github.com/debben80/internxt-cli/releases)
[![Architecture](https://img.shields.io/badge/Arch-amd64%20%7C%20arm64%20%7C%20armv7-blue)](https://github.com/debben80/internxt-cli)
[![GitHub Actions Workflow Status](https://img.shields.io/github/actions/workflow/status/debben80/internxt-cli/publish.yml)](https://github.com/debben80/internxt-cli/actions/workflows/publish.yml)
[![Docker Pulls](https://img.shields.io/docker/pulls/debben80/internxt-cli?style=flat-square)](https://hub.docker.com/r/debben80/internxt-cli)
[![GitHub Container Registry](https://img.shields.io/badge/GHCR-debben80%2Finternxt--cli-blue?logo=github&style=flat-square)](https://github.com/users/debben80/packages/container/package/internxt-cli)
[![GitHub License](https://img.shields.io/github/license/debben80/internxt-cli?style=flat-square)](LICENSE)
# Internxt CLI Docker Image

This project provides a Docker image for running the [Internxt CLI](https://github.com/internxt/cli) and launching a **WebDAV server** backed by your Internxt cloud storage. It is designed for secure, automated deployments and supports two-factor authentication (TOTP), non-root execution, and flexible configuration via environment variables or secret files.

---

## Table of Contents

- [Features](#features)
- [Prerequisites](#prerequisites)
- [Environment Variables](#environment-variables)
- [Docker images](#docker-images)
- [Usage](#usage)
  - [Start the WebDAV Server](#start-the-webdav-server)
  - [Run Internxt CLI Commands](#run-internxt-cli-commands)
  - [Using Secrets](#using-secrets)
- [Docker Compose Example](#docker-compose-example)
- [Security Notes](#security-notes)
- [Development](#development)
- [References](#references)
- [License](#license)

---

## Features

- **Secure login** to Internxt with email, password, and optional TOTP (2FA).
- **Automatic WebDAV server activation** if no command is passed.
- **Flexible environment variable management** (direct or via secret files).
- **Run any Internxt CLI command** inside the container.
- **Non-root user** execution for improved security.
- **Configurable WebDAV protocol, port, and logging level**.
- **Configurable TimeZone**.
- **Multi-arch builds** for `amd64` , `arm64` and `armv7`.

---

## Prerequisites

- An [Internxt](https://internxt.com/) account.
- [Docker](https://docs.docker.com/get-docker/) installed.

---

## Environment Variables

You can configure the container using the following environment variables:

| Variable                     | Description                                               | Required | Default  |
|------------------------------|-----------------------------------------------------------|:--------:|---------:|
| `INTERNXT_EMAIL`             | Internxt login email.                                     | **Yes**  |          |
| `INTERNXT_PASSWORD`          | Internxt login password.                                  | **Yes**  |          |
| `INTERNXT_TOTP_CODE`         | TOTP code for two-factor authentication.                  | No       |          |
| `INTERNXT_TOTP_SECRET`       | TOTP secret for 2FA (INTERNXT_TOTP_CODE have priority)    | No       |          |
| `WEBDAV_PROTO`               | Protocol for WebDAV (`http` or `https`).                  | No       | `https`  |
| `WEBDAV_PORT`                | WebDAV listening port.                                    | No       | `3005`   |
| `WEBDAV_LOGS`                | Log level (`error` or `debug`).                           | No       | `error`  |
| `PUID`                       | User ID for running processes.                            | No       | `1000`   |
| `PGID`                       | Group ID for running processes.                           | No       | `1000`   |
| `TZ`                         | TimeZone for tzdata                                       | No       | `Etc/UTC`|

> **Tip:** For any `INTERNXT_*` variable above, you can use a corresponding `*_FILE` variable to load its value from a file (useful for secrets).

---

### Docker Images
 | Registry                      | Address ( tag : `latest` )                         |
 |-------------------------------|----------------------------------------------------|
 | **Docker Hub**                | `docker pull debben80/internxt-cli:latest`         |
 | **GitHub Container Registry** | `docker pull ghcr.io/debben80/internxt-cli:latest` |
 
---

## Usage

### Start the WebDAV Server

```sh
docker run -d \
  -e INTERNXT_EMAIL=my@email.com \
  -e INTERNXT_PASSWORD=mypassword \
  -e INTERNXT_TOTP_SECRET=myTOTPsecret \
  debben80/internxt-cli
```

### Run Internxt CLI Commands

You can run any Internxt CLI command by passing it as arguments:

```sh
docker run --rm \
  -e INTERNXT_EMAIL=my@email.com \
  -e INTERNXT_PASSWORD=mypassword \
  -e INTERNXT_TOTP_CODE=myTOTPcode \
  debben80/internxt-cli internxt list
```

### Using Secrets

To use secrets, mount files and set the corresponding `*_FILE` environment variable:

```sh
docker run -d \
  -e INTERNXT_EMAIL_FILE=/run/secrets/email \
  -e INTERNXT_PASSWORD_FILE=/run/secrets/password \
  -v /run/secrets:/run/secrets:ro \
  debben80/internxt-cli
```

---

## Docker Compose Example

```yaml
services:
  internxt-webdav:
    image: debben80/internxt-cli:latest
    environment:
      INTERNXT_EMAIL: your@email.com
      INTERNXT_PASSWORD: yourpassword
    ports:
      - "3005:3005"
    restart: unless-stopped
```

---

## Security Notes

- The container runs as a non-root user (`appuser`).
- Secrets can be injected via files for improved security.
- Always use secure passwords and enable TOTP if possible.

---

## Development

- The Docker image is built using [Alpine Linux](https://alpinelinux.org/).
- The Internxt CLI is installed via npm.
- Entrypoint and helper scripts are located in [`app/entrypoint.sh`](app/entrypoint.sh), [`app/functions.sh`](app/functions.sh), and [`app/webdav.sh`](app/webdav.sh).

---

## References

- [Project Github Page](https://github.com/debben80/internxt-cli)
- [Docker Hub Page](https://hub.docker.com/r/debben80/internxt-cli)
- [Internxt CLI Documentation](https://github.com/internxt/cli)

---

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
