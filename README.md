# Internxt CLI Docker Image

This project provides a Docker image for running the [Internxt CLI](https://github.com/internxt/cli) and launching a **WebDAV server** backed by your Internxt cloud storage. It is designed for secure, automated deployments and supports two-factor authentication (TOTP), non-root execution, and flexible configuration via environment variables or secret files.

---

## Features

- **Secure login** to Internxt with email, password, and optional TOTP (2FA).
- **Automatic WebDAV server activation** if no command is passed.
- **Flexible environment variable management** (direct or via secret files).
- **Run any Internxt CLI command** inside the container.
- **Non-root user** execution for improved security.
- **Configurable WebDAV protocol, port, and logging level**.
- **Multi-arch builds** for `amd64` and `arm64`.

---

## Prerequisites

- An [Internxt](https://internxt.com/) account.
- [Docker](https://docs.docker.com/get-docker/) installed.

---

## Environment Variables

You can configure the container using the following environment variables:

| Variable                     | Description                                                         | Required | Default |
|------------------------------|---------------------------------------------------------------------|----------|---------|
| `INTERNXT_EMAIL`             | Internxt login email.                                               | Yes      |         |
| `INTERNXT_PASSWORD`          | Internxt login password.                                            | Yes      |         |
| `INTERNXT_TOTP_SECRET`       | TOTP secret for two-factor authentication.                          | No       |         |
| `WEBDAV_PROTO`               | Protocol for WebDAV (`http` or `https`).                            | No       | `https` |
| `WEBDAV_PORT`                | WebDAV listening port.                                              | No       | `3005`  |
| `WEBDAV_LOGS`                | Log level (`error` or `debug`).                                     | No       | `error` |
| `PUID`                       | User ID for running processes.                                      | No       | `1000`  |
| `PGID`                       | Group ID for running processes.                                     | No       | `1000`  |

> **Tip:** For any **INTERNXT_** variable above, you can use a corresponding `*_FILE` variable to load its value from a file (useful for secrets).

---

## Usage

### 1. Build the Docker Image

```sh
docker build -t internxt-cli .
```

### 2. Start the WebDAV Server

```sh
docker run -d \
  -e INTERNXT_EMAIL=my@email.com \
  -e INTERNXT_PASSWORD=mypassword \
  -e INTERNXT_TOTP_SECRET=myTOTPsecret \
  internxt-cli
```

### 3. Run Internxt CLI Commands

You can run any Internxt CLI command by passing it as arguments:

```sh
docker run --rm \
  -e INTERNXT_EMAIL=my@email.com \
  -e INTERNXT_PASSWORD=mypassword \
  -e INTERNXT_TOTP_SECRET=myTOTPsecret \
  internxt-cli internxt list
```

### 4. Using Secrets

To use secrets, mount files and set the corresponding `*_FILE` environment variable:

```sh
docker run -d \
  -e INTERNXT_EMAIL_FILE=/run/secrets/email \
  -e INTERNXT_PASSWORD_FILE=/run/secrets/password \
  -v /run/secrets:/run/secrets:ro \
  internxt-cli
```

---

## Docker Compose Example

```yaml
version: '3.8'
services:
  internxt-webdav:
    image: internxt-cli:latest
    environment:
      INTERNXT_EMAIL: your@email.com
      INTERNXT_PASSWORD: yourpassword
      WEBDAV_PORT: 3005
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

- [Internxt CLI Documentation](https://github.com/internxt/cli)