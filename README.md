# Radarr in Docker optimized for Unraid
Radarr A fork of Sonarr to work with movies à la Couchpotato.

UPDATE: The container will check on every start/restart if there is a newer version available (you can also choose between stabel and nightly version - keep in mind that switching from a stable to a nightly version and vice versa will/can break the container).

MANUAL VERSION: You can also set a version manually by typing in the version number that you want to use for example: '0.2.0.1480' (without quotes) - you can also change it to 'latest' or 'nightly' like described above (works only for stable builds - don't forget to disable updates in the WebGUI if you are using a specific version).

ATTENTION: Don't change the port in the Radarr config itself.

MIGRATION: If you are migrating from another Container please be sure to deltete the files/folders 'logs', 'xdg' and 'config.xml', don't forget to change the root folder for your movies to '/mnt/movies' and select 'No, I'll Move the Files Myself'!


## Env params
| Name | Value | Example |
| --- | --- | --- |
| DATA_DIR | Folder for configfiles and the application | /radarr |
| RADARR_REL | Select if you want to download a stable or prerelease | nightly |
| MONO_START_PARAMS | Only change if you know what you are doing! | --debug |
| UID | User Identifier | 99 |
| GID | Group Identifier | 100 |
| UMASK | Umask value for new created files | 0000 |
| DATA_PERMS | Data permissions for config folder | 770 |

## Run example
```
docker run --name Radarr -d \
	-p 7878:7878 \
	--env 'RADARR_REL=nightly' \
	--env 'MONO_START_PARAMS=--debug' \
	--env 'UID=99' \
	--env 'GID=100' \
	--env 'UMASK=0000' \
	--env 'DATA_PERMS=770' \
	--volume /mnt/cache/appdata/radarr:/radarr \
	--volume /mnt/user/Movies:/mnt/movies \
	--volume /mnt/user/Downloads:/mnt/downloads \
	ich777/radarr
```

This Docker was mainly edited for better use with Unraid, if you don't use Unraid you should definitely try it!

#### Support Thread: https://forums.unraid.net/topic/83786-support-ich777-application-dockers/