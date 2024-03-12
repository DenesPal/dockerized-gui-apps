FROM ubuntu:latest

RUN apt-get update && \
  apt-get upgrade -y && \
  apt-get install -y openjdk-8-jre wget && \
  # clean up
  apt-get clean && \
  rm -rf /var/lib/apt/lists && rm -rf ~/.cache

ARG USER=user
ARG HOME=/home/$USER
ARG UID=1000

RUN useradd --home-dir $HOME --user-group --create-home --uid $UID $USER && \
  mkdir /usr/share/abevjava/ && chown $UID:$UID /usr/share/abevjava && \
  touch /etc/abevjavapath.cfg && chown $UID:$UID /etc/abevjavapath.cfg

USER $USER
WORKDIR $HOME

ARG DOWNLOAD_URL=https://nav.gov.hu/pfile/programFile?path=/nyomtatvanyok/letoltesek/nyomtatvanykitolto_programok/nyomtatvany_apeh/keretprogramok/AbevJava
ARG TEMP_FILE=/tmp/abevjava-install.jar
RUN wget --no-verbose --timeout 60 --tries 2 --output-document "$TEMP_FILE" "$DOWNLOAD_URL" && \
  java -jar "$TEMP_FILE" -s -u && \
  rm "$TEMP_FILE"

ARG DOWNLOAD_URL=https://nav.gov.hu/pfile/programFile?path=/nyomtatvanyok/letoltesek/nyomtatvanykitolto_programok/nyomtatvanykitolto_programok_nav/igazol/NAV_igazol
ARG TEMP_FILE=/tmp/nav-igazol.jar
RUN wget --no-verbose --timeout 60 --tries 2 --output-document "$TEMP_FILE" "$DOWNLOAD_URL" && \
  java -jar "$TEMP_FILE" -s -u && \
  rm "$TEMP_FILE"

CMD cd /usr/share/abevjava && ./abevjava_start
