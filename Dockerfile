FROM debian:buster
LABEL mainteiner = Igor Olhovskiy <IgorOlhovskiy@gmail.com>

# Install Required Dependencies
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y \
        ca-certificates \
        git \
        ssl-cert \
        ghostscript \
        libtiff5-dev \
        libtiff-tools \
        wget \
        curl \
        openssh-server \
        supervisor \
        net-tools \
        gnupg2 \
        netcat \
    && wget -O - https://files.freeswitch.org/repo/deb/debian-release/fsstretch-archive-keyring.asc | apt-key add - \
    && echo "deb http://files.freeswitch.org/repo/deb/debian-release/ buster main" > /etc/apt/sources.list.d/freeswitch.list \
    && apt-get update \
    && apt-get install -y \
        freeswitch-meta-bare \
        freeswitch-conf-vanilla \
        freeswitch-mod-commands \
        freeswitch-mod-console \
        freeswitch-mod-logfile \
        freeswitch-lang-en \
        freeswitch-mod-say-en \
        freeswitch-sounds-en-us-callie \
        freeswitch-mod-enum \
        freeswitch-mod-cdr-csv \
        freeswitch-mod-event-socket \
        freeswitch-mod-sofia \
        freeswitch-mod-loopback \
        freeswitch-mod-conference \
        freeswitch-mod-db \
        freeswitch-mod-dptools \
        freeswitch-mod-expr \
        freeswitch-mod-fifo \
        freeswitch-mod-httapi \
        freeswitch-mod-hash \
        freeswitch-mod-esl \
        freeswitch-mod-esf \
        freeswitch-mod-fsv \
        freeswitch-mod-valet-parking \
        freeswitch-mod-dialplan-xml \
        freeswitch-mod-sndfile \
        freeswitch-mod-native-file \
        freeswitch-mod-local-stream \
        freeswitch-mod-tone-stream \
        freeswitch-mod-lua \
        freeswitch-meta-mod-say \
        freeswitch-mod-xml-cdr \
        freeswitch-mod-verto \
        freeswitch-mod-callcenter \
        freeswitch-mod-rtc \
        freeswitch-mod-png \
        freeswitch-mod-json-cdr \
        freeswitch-mod-shout \
        freeswitch-mod-sms \
        freeswitch-mod-sms-dbg \
        freeswitch-mod-cidlookup \
        freeswitch-mod-memcache \
        freeswitch-mod-imagick \
        freeswitch-mod-tts-commandline \
        freeswitch-mod-directory \
        freeswitch-mod-flite \
        freeswitch-mod-distributor \
        freeswitch-meta-codecs \
        freeswitch-mod-pgsql \
        freeswitch-music-default \
    && chown -R freeswitch:freeswitch /var/lib/freeswitch \
    && chmod -R ug+rw /var/lib/freeswitch \
    && find /var/lib/freeswitch -type d -exec chmod 2770 {} \; \
    && mkdir /usr/share/freeswitch/scripts \
    && chown -R freeswitch:freeswitch /usr/share/freeswitch \
    && chmod -R ug+rw /usr/share/freeswitch \
    && find /usr/share/freeswitch -type d -exec chmod 2770 {} \; \
    && chown -R freeswitch:freeswitch /etc/freeswitch \
    && chmod -R ug+rw /etc/freeswitch \
    && find /etc/freeswitch -type d -exec chmod 2770 {} \; \
    && chown -R freeswitch:freeswitch /var/log/freeswitch \
    && chmod -R ug+rw /var/log/freeswitch \
    && find /var/log/freeswitch -type d -exec chmod 2770 {} \; \
    && find /etc/freeswitch/autoload_configs/event_socket.conf.xml -type f -exec sed -i 's/::/127.0.0.1/g' {} \; \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ADD ./supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD start-freeswitch.sh /usr/bin/start-freeswitch.sh

# CPBX part
ADD bin/cpbx /opt/cpbx
RUN chmod +x /opt/cpbx
ADD config/config.json /opt/config.json

EXPOSE 5060/udp
EXPOSE 8080/tcp

VOLUME ["/etc/freeswitch", "/var/lib/freeswitch", "/usr/share/freeswitch"]

CMD /usr/bin/supervisord -n