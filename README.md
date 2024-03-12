Dockerized some GUI apps, stolen bits of ideas form everywhere

# icaclient

 - Citrix Workspace app / desktop receiver / wfica client.
 - Has a Firefox web browser installed for accessing the corporate login page.
 - Mounts a pseudonymouos volume to /home/user
 - Mounts ~/Desktoop as /home/user/Desktop
 - Has no sound and camera
 - Rebuilds with latest Citrix Workspace app version on latest ubuntu LTS.

Use `docker compose up -d --wait icaclient` to start the container, and
`docker compose exec icaclient firefox` to start the browser every time
you need to log in. If you save settings or passwords, they get saved
into the volume mounted as home, perhaps not safe to store sensitive info.

The container keeps running in the background, even when the browser or
the Icaclient gets closed. Icaclient keeps some background services running
in the container, so if they misbehave, or you want to get rid of them,
`docker compose down`

Example connecting script into `~/.local/bin/`

```shell
#!/bin/sh
#exec ssh -f -X -l receiver -p 722 localhost /usr/bin/firefox https://citrixportal.novonordisk.com/
cd ~/dockerized-gui-apps
docker compose up -d --wait icaclient && exec docker compose exec icaclient firefox
```

Example desktop file into `~/.local/share/applications/`

```ini
[Desktop Entry]
Encoding=UTF-8
Version=1.0
Type=Application
Name=Citrix Workspace
StartupWMClass=Firefox
NoDisplay=false
MimeType=application/x-ica;
Categories=Application;Network;
TryExec=/home/USER/.local/bin/citrix.sh
Exec=/home/USER/.local/bin/citrix.sh
```


# Opera

Just Opera web browser with sound (pulseaudio) and probably
very inefficient video playback.

`docker compose up opera` will start the browser,
and will stop the container if browser exits.


# Abevjava

Általános Nyomtatványkitöltő (ÁNYK) program is for filling electronic forms
of Hungarian authorities, most notably the tax office.

`docker compose up abevjava` will start the ÁNYK and
container will stop when it exits.

~/Desktop is mounted into the container as /home/user/Desktop for exchanging
files. Additional forms can be downloaded with a browser running on the
host computer, or Opera.

