#!/bin/sh
cd /home/tf2server/tf2
/home/tf2server/tf2/srcds_run \
    -game tf \
    -console \
    -nohltv \
    -sv_pure 0 \
    +map vsh_manncohq_v14 \
    +maxplayers 24 \
    -autoupdate \
    -steam_dir /home/tf2server/SteamCMD/ \
    -steamcmd_script /home/tf2server/SteamCMD/tf2_ds.txt \
    +sv_shutdown_timeout_minutes 30
