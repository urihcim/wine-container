# wine-container

This project provides a Docker environment for running Wine, a compatibility layer for running Windows applications on Linux.  
It also includes xrdp for remote desktop access via RDP.  
With this container, you can easily run Windows programs and access a Linux desktop remotely, without installing Wine or xrdp on your host system.

## Features

- Run Windows applications using Wine inside Docker
- Remote desktop access via xrdp (RDP protocol)

## Usage

### Build the Docker image

```sh
docker build -t wine-container .
```

### Start a desktop session and connect via Remote Desktop (xrdp)

```sh
docker run -it -p 3389:3389 wine-container /bin/bash
```

- Connect to `localhost:3389` using any RDP client.
- The default user is `wineuser`. The password is auto-generated unless specified.
- You can customize the user, DPI, keyboard layout, and timezone using environment variables.

### Environment Variables

- `USER_NAME`: Username for the desktop session (default: wineuser)
- `USER_PASSWD`: Password for the user (auto-generated if not set)
- `TZ`: Timezone (default: UTC)
- `RUN_AS_ROOT`: Run commands as root if set
- `DPI`: DPI setting for the desktop (e.g., 96, 120)
- `KEYMAP`: Keyboard layout for xrdp (e.g., en:0xe0010411)

## Requirements

- Docker

## License

MIT License
