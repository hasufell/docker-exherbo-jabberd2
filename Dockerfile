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
	cave resolve -ks -Sa -sa -B world -x -f --permit-old-version '*/*' && \
	cave resolve -ks -Sa -sa -B world -x --permit-old-version '*/*' && \
	cave purge -x && \
	cave fix-linkage -x && \
	rm -rf /usr/portage/distfiles/*

RUN eclectic config accept-all

################################


COPY ./config/supervisord.conf /etc/supervisord.conf

EXPOSE 5222 5223 5269

CMD exec /usr/bin/supervisord -n -c /etc/supervisord.conf
