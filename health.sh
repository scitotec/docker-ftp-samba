#!/bin/sh


mountpoint /mnt/samba
if [ $? -ne 0 ]; then
  echo "mount point isn't ready"
  exit 1
fi

wget -O - ftp://healthcheck:iWontWork@127.0.0.1 | grep 530
if [ $? -ne 0 ]; then
  echo "ftp server isn't up"
  exit 2
fi
