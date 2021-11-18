#!/bin/sh

#Remove all ftp users
if [ -e /added-users ]; then
  cat /added-users | xargs -n1 deluser
  rm /added-users
fi

#Create user
if [ -z "$FTP_USERNAME" ]; then echo "missing FTP_USERNAME"; exit 1; fi
if [ -z "$FTP_PASSWORD" ]; then echo "missing FTP_PASSWORD"; exit 1; fi

NAME="$FTP_USERNAME"
PASS="$FTP_PASSWORD"
FOLDER="/mnt/samba"
LOCAL_UID="${LOCAL_UID:-1337}"

echo -e "$PASS\n$PASS" | adduser -h $FOLDER -s /sbin/nologin -u $LOCAL_UID $NAME
echo "$NAME" >> /added-users
mkdir -p $FOLDER
chown $NAME:$NAME $FOLDER



if [ -z "$MIN_PORT" ]; then
  MIN_PORT=21000
fi

if [ -z "$MAX_PORT" ]; then
  MAX_PORT=21010
fi

if [ ! -z "$ADDRESS" ]; then
  ADDR_OPT="-opasv_address=$ADDRESS"
fi

# prepare samba access
cat >/etc/samba-credentials <<EOL
username=$SMB_USERNAME
password=$SMB_PASSWORD
domain=$SMB_DOMAIN
EOL
SMB_VERSION="${SMB_VERSION:-default}"
if [ ! -z "$SMB_OPTS" ]; then
  SMB_OPTS=",$SMB_OPTS"
fi

if [ -z "$SMB_URL" ]; then echo "missing SMB_URL"; exit 1; fi
mount -t cifs -o "uid=$LOCAL_UID,gid=$LOCAL_UID,credentials=/etc/samba-credentials,vers=$SMB_VERSION$SMB_OPTS" "$SMB_URL" "$FOLDER"
if [ $? -ne 0 ]; then
  echo "could not mount samba"
  exit 2
fi

# Used to run custom commands inside container
if [ ! -z "$1" ]; then
  exec "$@"
else
  exec /usr/sbin/vsftpd -opasv_min_port=$MIN_PORT -opasv_max_port=$MAX_PORT $ADDR_OPT /etc/vsftpd/vsftpd.conf
fi

