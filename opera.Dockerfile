FROM ubuntu:latest

RUN apt-get update && \
  apt-get upgrade -y && \
  apt-get install -y wget && \
  wget -q -t2 -T60 -O- https://deb.opera.com/archive.key > /etc/apt/trusted.gpg.d/opera.asc && \
  echo "deb https://deb.opera.com/opera-stable/ stable non-free" > /etc/apt/sources.list.d/opera-stable.list && \
  apt-get update && \
  apt-get install -y opera-stable libpulse0 && \
  # clean up
  apt-get clean && \
  rm -rf /var/lib/apt/lists && rm -rf ~/.cache

ARG USER=user
ARG HOME=/home/$USER
ARG UID=1000

RUN useradd --home-dir $HOME --user-group --create-home --uid $UID $USER

USER $USER
WORKDIR $HOME
CMD opera --no-sandbox
