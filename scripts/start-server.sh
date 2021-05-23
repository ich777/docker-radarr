#!/bin/bash
ARCH="arm"
if [ "$RADARR_REL" == "latest" ]; then
    LAT_V="$(wget -qO- https://github.com/ich777/versions/raw/master/Radarr | grep LATEST | cut -d '=' -f2)"
elif [ "$RADARR_REL" == "nightly" ]; then
    LAT_V="$(wget -qO- https://github.com/ich777/versions/raw/master/Radarr | grep NIGHTLY | cut -d '=' -f2)"
else
    echo "---Version manually set to: v$RADARR_REL---"
    LAT_V="$RADARR_REL"
fi

if [ ! -f ${DATA_DIR}/logs/radarr.txt ]; then
    CUR_V=""
else
    CUR_V="$(cat ${DATA_DIR}/logs/radarr.txt | grep " - Version" | tail -1 | rev | cut -d ' ' -f1 | rev)"
fi

if [ -z $LAT_V ]; then
    if [ -z $CUR_V ]; then
        echo "---Can't get latest version of Radarr, putting container into sleep mode!---"
        sleep infinity
    else
        echo "---Can't get latest version of Radarr, falling back to v$CUR_V---"
    fi
fi

if [ -f ${DATA_DIR}/Radarr-v$LAT_V.tar.gz ]; then
    rm ${DATA_DIR}/Radarr-v$LAT_V.tar.gz
fi

echo "---Version Check---"
if [ "$RADARR_REL" == "nightly" ]; then
    if [ -z "$CUR_V" ]; then
        echo "---Radarr not found, downloading and installing v$LAT_V...---"
        cd ${DATA_DIR}
        if wget -q -nc --show-progress --progress=bar:force:noscroll -O ${DATA_DIR}/Radarr-v$LAT_V.tar.gz "https://radarr.servarr.com/v1/update/nightly/updatefile?version=${LAT_V}&os=linux&runtime=netcore&arch=${ARCH}" ; then
            echo "---Successfully downloaded Radarr v$LAT_V---"
        else
            rm ${DATA_DIR}/Radarr-v$LAT_V.tar.gz
            if wget -q -nc --show-progress --progress=bar:force:noscroll -O ${DATA_DIR}/Radarr-v$LAT_V.tar.gz "https://github.com/ich777/Radarr/releases/download/${LAT_V}/v${LAT_V}-${ARCH}.tar.gz" ; then
                echo "---Successfully downloaded Radarr v$LAT_V---"
            else
                echo "---Something went wrong, can't download Radarr v$LAT_V, putting container into sleep mode!---"
                sleep infinity
            fi
        fi
        mkdir ${DATA_DIR}/Radarr
        tar -C ${DATA_DIR}/Radarr --strip-components=1 -xf ${DATA_DIR}/Radarr-v$LAT_V.tar.gz
        rm ${DATA_DIR}/Radarr-v$LAT_V.tar.gz
    elif [ "$CUR_V" != "$LAT_V" ]; then
        echo "---Version missmatch, installed v$CUR_V, downloading and installing latest v$LAT_V...---"
        cd ${DATA_DIR}
        if wget -q -nc --show-progress --progress=bar:force:noscroll -O ${DATA_DIR}/Radarr-v$LAT_V.tar.gz "https://radarr.servarr.com/v1/update/nightly/updatefile?version=${LAT_V}&os=linux&runtime=netcore&arch=${ARCH}" ; then
            echo "---Successfully downloaded Radarr v$LAT_V---"
        else
            rm ${DATA_DIR}/Radarr-v$LAT_V.tar.gz
            if wget -q -nc --show-progress --progress=bar:force:noscroll -O ${DATA_DIR}/Radarr-v$LAT_V.tar.gz "https://github.com/ich777/Radarr/releases/download/${LAT_V}/v${LAT_V}-${ARCH}.tar.gz" ; then
                echo "---Successfully downloaded Radarr v$LAT_V---"
            else
                echo "---Something went wrong, can't download Radarr v$LAT_V, putting container into sleep mode!---"
                sleep infinity
            fi
        fi
        rm -R ${DATA_DIR}/Radarr
        mkdir ${DATA_DIR}/Radarr
        tar -C ${DATA_DIR}/Radarr --strip-components=1 -xf ${DATA_DIR}/Radarr-v$LAT_V.tar.gz
        rm ${DATA_DIR}/Radarr-v$LAT_V.tar.gz
    elif [ "$CUR_V" == "$LAT_V" ]; then
        echo "---Radarr v$CUR_V up-to-date---"
    fi
else
    if [ -z "$CUR_V" ]; then
        echo "---Radarr not found, downloading and installing v$LAT_V...---"
        cd ${DATA_DIR}
        if wget -q -nc --show-progress --progress=bar:force:noscroll -O ${DATA_DIR}/Radarr-v$LAT_V.tar.gz "https://github.com/Radarr/Radarr/releases/download/v${LAT_V}/Radarr.develop.${LAT_V}.linux.tar.gz" ; then
            echo "---Successfully downloaded Radarr v$LAT_V---"
        else
            echo "---Something went wrong, can't download Radarr v$LAT_V, putting container into sleep mode!---"
            sleep infinity
        fi
        mkdir ${DATA_DIR}/Radarr
        tar -C ${DATA_DIR}/Radarr --strip-components=1 -xf ${DATA_DIR}/Radarr-v$LAT_V.tar.gz
        rm ${DATA_DIR}/Radarr-v$LAT_V.tar.gz
    elif [ "$CUR_V" != "$LAT_V" ]; then
        echo "---Version missmatch, installed v$CUR_V, downloading and installing latest v$LAT_V...---"
        cd ${DATA_DIR}
        if wget -q -nc --show-progress --progress=bar:force:noscroll -O ${DATA_DIR}/Radarr-v$LAT_V.tar.gz "https://github.com/Radarr/Radarr/releases/download/v${LAT_V}/Radarr.develop.${LAT_V}.linux.tar.gz" ; then
            echo "---Successfully downloaded Radarr v$LAT_V---"
        else
            echo "---Something went wrong, can't download Radarr v$LAT_V, putting container into sleep mode!---"
            sleep infinity
        fi
        rm -R ${DATA_DIR}/Radarr
        mkdir ${DATA_DIR}/Radarr
        tar -C ${DATA_DIR}/Radarr --strip-components=1 -xf ${DATA_DIR}/Radarr-v$LAT_V.tar.gz
        rm ${DATA_DIR}/Radarr-v$LAT_V.tar.gz
    elif [ "$CUR_V" == "$LAT_V" ]; then
        echo "---Radarr v$CUR_V up-to-date---"
    fi
fi

echo "---Preparing Server---"
if [ ! -f ${DATA_DIR}/config.xml ]; then
    echo "<Config>
  <LaunchBrowser>False</LaunchBrowser>
</Config>" > ${DATA_DIR}/config.xml
fi
if [ -f ${DATA_DIR}/nzbdrone.pid ]; then
    rm ${DATA_DIR}/nzbdrone.pid
elif [ -f ${DATA_DIR}/radarr.pid ]; then
    rm ${DATA_DIR}/radarr.pid
fi
chmod -R ${DATA_PERM} ${DATA_DIR}

echo "+-------------------------------------------------------------"
echo "|"
echo "| This container for ARM is deprecated and is no"
echo "| longer actively maintained or further developed!"
echo "|"
echo "|  Container will start in 60 seconds!"
echo "|"
echo "+-------------------------------------------------------------"
sleep 60

echo "---Starting Radarr---"
cd ${DATA_DIR}
if [ "$RADARR_REL" == "nightly" ]; then
    ${DATA_DIR}/Radarr/Radarr -nobrowser -data=${DATA_DIR} ${START_PARAMS}
else
    /usr/bin/mono ${MONO_START_PARAMS} ${DATA_DIR}/Radarr/Radarr.exe -nobrowser -data=${DATA_DIR} ${START_PARAMS}
fi