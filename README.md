# docker-ftp-samba

[![Docker Stars](https://img.shields.io/docker/stars/scitotec/ftp-samba.svg)](https://hub.docker.com/r/scitotec/ftp-samba/)
[![Docker Pulls](https://img.shields.io/docker/pulls/scitotec/ftp-samba.svg)](https://hub.docker.com/r/scitotec/ftp-samba/)
[![Docker Automated build](https://img.shields.io/docker/automated/scitotec/ftp-samba.svg)](https://hub.docker.com/r/scitotec/ftp-samba/)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![GitHub Repo stars](https://img.shields.io/github/stars/scitotec/docker-ftp-samba?style=social)](https://github.com/scitotec/docker-ftp-samba)

Run an vsftpd server to access your files on a CIFS (SMB) share.

## Why?

To access the share from software that has no proper or stable CIFS library/adapter.

## Usage

```
docker run -d \
    -p 21:21 \
    -p 21000-21010:21000-21010 \
    -e ADDRESS=ftp.site.domain \
    -e FTP_USERNAME=anne \
    -e FTP_PASSWORD=123123 \
    -e SMB_URL=//myserver/pictures \
    -e SMB_USERNAME=ben \
    -e SMB_PASSWORD=321321 \
    --cap-add SYS_ADMIN \
    --cap-add DAC_READ_SEARCH \
    scitotec/ftp-samba
```

## Configuration

Mounting in Docker **requires additional capabilities**, so be sure to add them. You have to add `SYS_ADMIN` and `DAC_READ_SEARCH` like discussed here: [Docker Issue](https://github.com/moby/moby/issues/22197), [Stackoverflow Post](https://stackoverflow.com/a/40330794/2672096).

### Environment variables:


| Required | Variable       | Default Value |  Description                    |
|   :---:  |----------------|---------------|---------------------------------|
|    yes   | `FTP_USERNAME` |               | the username to connect to the FTP server |
|    yes   | `FTP_PASSWORD` |               | the password to connect to the FTP server |
|    yes   | `SMB_URL`      |               | the URL to your share - may use `/` instead of `\`. E.g. `//myserver/pictures` |
|          | `SMB_USERNAME` |               | the username to connect to the SMB share |
|          | `SMB_PASSWORD` |               | the password to connect to the SMB share |
|          | `SMB_DOMAIN`   |               | the domain to connect to the SMB share   |
|          | `SMB_VERSION`  | `default`     | set the SMB protocol version (see [mount.cifs(8)](https://manpages.debian.org/bullseye/cifs-utils/mount.cifs.8.en.html#vers=arg)) |
|          | `ADDRESS`      |               | external address witch clients can connect passive ports |
|          | `MIN_PORT`     | `21000`       | minimum port number to be used for passive connections   |
|          | `MAX_PORT`     | `21010`       | maximum port number to be used for passive connections   |
|          | `LOCAL_UID`    | `1337`        | local unix user id for the ftp user and cifs mount       |
|          | `SMB_OPTS`     |               | custom options to pass to the mount command (see [mount.cifs(8)](https://manpages.debian.org/bullseye/cifs-utils/mount.cifs.8.en.html#vers=arg)) |
