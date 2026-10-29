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

## Releases

Releases are automated with [release-please](https://github.com/googleapis/release-please).

1. Commits on `main` follow [Conventional Commits](https://www.conventionalcommits.org/). Dependabot uses `fix(deps):` for Docker updates and `chore(deps):` for GitHub Actions updates.
2. release-please keeps a release PR open that bumps `.release-please-manifest.json` and updates `CHANGELOG.md`. `fix` bumps the patch version, `feat` bumps the minor version, and a breaking change bumps the major version.
3. Merging the release PR creates the `v*` tag and GitHub Release, and dispatches the image build for that tag.

Images are published to `ghcr.io/urihcim/wine`: `X.Y.Z` for each release and `latest` for the head of `main`.

`chore` commits (including GitHub Actions updates) do not trigger a release on their own.

## Requirements

- Docker

## License

MIT License
