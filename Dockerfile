FROM ppc64le/debian:jessie

RUN echo "deb http://ftp.debian.org/debian jessie-backports main" >> /etc/apt/sources.list \
 && apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get -y --no-install-recommends install \
	rsyslog \
	supervisor \
	opensmtpd \
	spamc \
	spampd \
	spamassassin \
	dovecot-imapd \
	dovecot-pop3d \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Create app structure
ADD supervisord.conf /etc/supervisor/conf.d/

# Push key and cert ssl
ADD etc/ssl/private/mail.marathon-slave-2.slash16.local.key /etc/ssl/private/
ADD etc/ssl/certs/mail.marathon-slave-2.slash16.local.crt /etc/ssl/certs/
RUN chmod 700 /etc/ssl/private/mail.marathon-slave-2.slash16.local.key
RUN chmod 700 /etc/ssl/certs/mail.marathon-slave-2.slash16.local.crt

# OpenSMTPD
ADD etc/smtpd.conf /etc/smtpd.conf

# Dovecot
ADD etc/dovecot/dovecot.conf /etc/dovecot/

# Spamassassin
run sed -i 's/ENABLED=0/ENABLED=1/' /etc/default/spamassassin

# forwards ports smtp and imap
EXPOSE 25 587


CMD /usr/bin/supervisord

