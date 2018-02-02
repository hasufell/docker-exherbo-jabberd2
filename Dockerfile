FROM        hasufell/exherbo
MAINTAINER  Julian Ospald <hasufell@posteo.de>


COPY ./config/paludis /etc/paludis

##### PACKAGE INSTALLATION #####

# update world with our options
RUN chgrp paludisbuild /dev/tty && \
	eclectic env update && \
	source /etc/profile && \
	cave sync && \
	cave resolve -z -1 repository/net -x && \
	cave resolve -z -1 repository/hasufell -x && \
	cave resolve -z -1 repository/python -x && \
	cave resolve -z -1 repository/mixi -x && \
	cave update-world -s jabber && \
	cave resolve -ks -Sa -sa -B world -x -f --permit-old-version '*/*' --without sys-apps/paludis && \
	cave resolve -ks -Sa -sa -B world -x --permit-old-version '*/*' --without sys-apps/paludis && \
	cave purge -x && \
	cave fix-linkage -x -- --without sys-apps/paludis && \
	rm -rf /var/cache/paludis/distfiles/* \
		/var/tmp/paludis/build/*

RUN eclectic config accept-all

################################

RUN mkdir -p /var/run/jabber /var/log/jabber && \
	chown jabber:jabber /var/run/jabber /var/log/jabber

COPY ./config/supervisord.conf /etc/supervisord.conf

EXPOSE 5222 5223 5269

CMD exec /usr/bin/supervisord -n -c /etc/supervisord.conf
