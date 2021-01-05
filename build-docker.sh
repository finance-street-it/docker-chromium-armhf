#!/bin/bash

DEFAULT_IMAGENAME="docker-chromium-armhf"

read -p "Specify the docker image name: (docker-chromium-armhf) " imagename

imagename=${imagename:-${DEFAULT_IMAGENAME}}

echo "Download flash file from Google to get the latest armhf libwidevinecdm.so"
[[ ! -f widevine-flash-armhf.tgz ]] && ./widevine-flash-armhf.sh

echo "Build docker image and copy the Widevine CDM library into it"
docker build -t ${imagename} .

echo "Generate wrapper for docker chromium"
echo "docker run --rm --privileged \\
 -e DISPLAY=unix\$DISPLAY \\
 -v chromium_home:/home \\
 -v /tmp/.X11-unix:/tmp/.X11-unix \\
 -v /dev:/dev -v /run:/run \\
 -v /etc/machine-id:/etc/machine-id \\
  ${imagename} \\
  chromium-streaming" > chromium-netflix

echo "Install standalone chromium docker executable" 
chmod 755 chromium-netflix
sudo install -m 755 chromium-netflix /usr/local/bin

echo "Copy desktop shortcut"
sudo cp chromium-media-browser.desktop /usr/share/applications
