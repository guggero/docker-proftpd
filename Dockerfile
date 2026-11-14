# proftpd
#
# ProFTPD server on Ubuntu 26.04 (ProFTPD 1.3.9).
#
# Configuration is expected to be mounted at /etc/proftpd/proftpd.conf. The
# PROFTPD_* environment variables are optional overrides that are only applied
# when explicitly set (see run-proftpd.sh).

FROM ubuntu:26.04

LABEL org.opencontainers.image.source="https://github.com/guggero/docker-proftpd" \
      org.opencontainers.image.description="ProFTPD server on Ubuntu 26.04"

# mod_tls lives in proftpd-mod-crypto since ProFTPD 1.3.8 (Debian/Ubuntu split).
RUN apt-get update \
  && DEBIAN_FRONTEND=noninteractive \
     apt-get install -y --no-install-recommends \
       proftpd-core proftpd-mod-crypto proftpd-mod-mysql \
  && rm -rf /var/lib/apt/lists/* \
  && mkdir -p -m 0755 /etc/proftpd/auth.d /etc/proftpd/user.d /run/proftpd \
  && mkdir -m 000 /var/ftp

# Copy in the default proftpd.conf files
COPY proftpd/*.conf /etc/proftpd/
COPY run-proftpd.sh /sbin/run-proftpd.sh

# Make the ftp, auth.d, conf.d, and user.d directories volumes
VOLUME /var/ftp /etc/proftpd/auth.d /etc/proftpd/conf.d /etc/proftpd/user.d

CMD []
ENTRYPOINT ["/sbin/run-proftpd.sh"]
