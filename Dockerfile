FROM balenalib/raspberry-pi-debian:latest

RUN apt update && apt install chromium-browser lsb-release xz-utils fontconfig fontconfig-config -y

ADD chromium-settings /etc/chromium-browser/default

ADD chromium-streaming /usr/bin/chromium-streaming
RUN chmod +x /usr/bin/chromium-streaming

COPY widevine-flash-armhf.tgz /tmp/widevine-flash-armhf.tgz
RUN tar -xzvf /tmp/widevine-flash-armhf.tgz -C /

ENV UNAME mediaguy
RUN export UNAME=$UNAME UID=1000 GID=1000 && \
    mkdir -p "/home/${UNAME}" && \
    echo "${UNAME}:x:${UID}:${GID}:${UNAME} User,,,:/home/${UNAME}:/bin/bash" >> /etc/passwd && \
    echo "${UNAME}:x:${UID}:" >> /etc/group && \
    mkdir -p /etc/sudoers.d && \
    echo "${UNAME} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/${UNAME} && \
    chmod 0440 /etc/sudoers.d/${UNAME} && \
    gpasswd -a ${UNAME} audio
USER $UNAME
ENV HOME /home/${UNAME}
