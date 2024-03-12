FROM ubuntu:latest

ARG DOWNLOAD_URL="https://www.citrix.com/downloads/workspace-app/linux/workspace-app-for-linux-latest.html"
ARG TMP_FILE=/tmp/icaclient.deb

RUN apt-get update && \
  apt-get upgrade -y && \
  apt-get install -y wget && \
  # install firefox
  wget --no-verbose --timeout 60 --tries 2 --output-document /etc/apt/keyrings/packages.mozilla.org.asc "https://packages.mozilla.org/apt/repo-signing-key.gpg" && \
  echo "deb [signed-by=/etc/apt/keyrings/packages.mozilla.org.asc] https://packages.mozilla.org/apt mozilla main" > /etc/apt/sources.list.d/mozilla.list && \
  apt-get update && \
  apt-get install -y firefox/mozilla && \
  # install icaclient
  DOWNLOAD_URL="$(wget -q -t2 -T60 -O- "$DOWNLOAD_URL" | sed -n -e '/\/\/.*\/icaclient_.*.deb/ s/<a .* rel="\([^"]*\)" id="downloadcomponent">/https:\1/p' | sed -e 's/\s//g')" && \
  test -n "$DOWNLOAD_URL" && \
  wget --no-verbose --timeout 60 --tries 2 --output-document "$TMP_FILE" "$DOWNLOAD_URL" && \
  apt-get install -y "$TMP_FILE" && \
  ln -s /usr/share/ca-certificates/mozilla/* /opt/Citrix/ICAClient/keystore/cacerts/ && \
  c_rehash /opt/Citrix/ICAClient/keystore/cacerts/  && \
  # cleanup
  rm "$TMP_FILE" && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists && rm -rf ~/.cache

ARG USER=user
ARG HOME=/home/$USER
ARG UID=1000

RUN useradd --home-dir $HOME --user-group --create-home --uid $UID $USER

USER $USER
WORKDIR $HOME
CMD firefox
