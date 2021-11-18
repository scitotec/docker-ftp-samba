FROM alpine:3.14
RUN apk --no-cache add vsftpd cifs-utils

COPY entrypoint.sh /entrypoint.sh
COPY health.sh /health.sh
COPY vsftpd.conf /etc/vsftpd/vsftpd.conf

EXPOSE 21 21000-21010

STOPSIGNAL SIGKILL

HEALTHCHECK CMD /health.sh

ENTRYPOINT ["/entrypoint.sh"]
