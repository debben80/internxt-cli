# Internxt-CLI

This project allows you to start a **WebDAV server** for **Internxt** in a Docker container. It uses an entrypoint script (`entrypoint.sh`) to handle secure login, enable the WebDAV server, and keep the container running.
If WebDAV mode is not enabled, this project can be used to launch **internxt** commands. 

---

## **Features**
- Secure login to Internxt with email, password, and TOTP (2FA) support.
- Automatic WebDAV server activation.
- Secure environment variable management (via files or direct variables).

---

## **Prerequisites**
- An **Internxt** account.
- **Docker** installed on your machine.

---

## **Environment Variables**
The script uses the following environment variables for configuration:

| Variable                     | Description                                                                 | Required? |
|------------------------------|-----------------------------------------------------------------------------|-----------|
| `WEBDAV_ENABLE`              | Enables WebDAV mode if set to `1`.                                          | No       |
| `INTERNXT_EMAIL`             | Internxt login email.                                                       | Yes       |
| `INTERNXT_PASSWORD`          | Internxt login password.                                                    | Yes       |
| `INTERNXT_TOTP_SECRET`       | TOTP secret for two-factor authentication.                                  | No        |

Variables can be used with secrets, just add **_FILE**

---

## **Usage with Docker**

### **1. Build the Docker Image**
```bash
docker build -t internxt-webdav .
```
### **2. Start the container**
```bash
docker run -d \
  -e WEBDAV_ENABLE=1 \
  -e INTERNXT_EMAIL=my@email.com \
  -e INTERNXT_PASSWORD=mypassword \
  -e INTERNXT_TOTP_SECRET=myTOTPsecret \
  internxt-webdav
```
