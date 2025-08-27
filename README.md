# Internxt-cli

This project allows you to start a **WebDAV server** for **Internxt** in a Docker container. It uses an entrypoint script (`entrypoint.sh`) to handle secure login. And start the WebDAV server if no commands is passed.
This container can be used to launch **internxt** commands.

---

## **Features**
- Secure login to Internxt with email, password, and TOTP (2FA) support.
- Automatic WebDAV server activation.
- Secure environment variable management (via files or direct variables).
- Use this container to launch internxt commands

---

## **Prerequisites**
- An **Internxt** account.
- **Docker** installed on your machine.

---

## **Environment Variables**
The script uses the following environment variables for configuration:

| Variable                     | Description                                                                 | Required? | Default |
|------------------------------|-----------------------------------------------------------------------------|-----------|---------|
| `INTERNXT_EMAIL`             | Internxt login email.                                                       | Yes       |         |
| `INTERNXT_PASSWORD`          | Internxt login password.                                                    | Yes       |         |
| `INTERNXT_TOTP_SECRET`       | TOTP secret for two-factor authentication.                                  | No        |         |
| `WEBDAV_PROTO`               | Protocol used for WebDAV `http` or `https`.                                 | No        | `https` |
| `WEBDAV_PORT`                | Listening port for WebDAV                                                   | No        | `3005`  |
| `WEBDAV_LOGS`                | Logs to output to stdout `error` or `debug`.                                | No        | `error` |

All **INTERNXT_** variables can be used with secrets, just add **_FILE**

---

## **Usage with Docker**

### **1. Build the Docker Image**
```bash
docker build -t internxt-cli .
```

### **2. Start the container**
```bash
docker run -d \
  -e INTERNXT_EMAIL=my@email.com \
  -e INTERNXT_PASSWORD=mypassword \
  -e INTERNXT_TOTP_SECRET=myTOTPsecret \
  internxt-cli
```
