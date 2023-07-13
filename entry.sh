#!/bin/sh

# Ensure User and Group IDs
if [ ! "$(id -u pzombie)" -eq "$UID" ]; then usermod -o -u "$UID" pzombie ; fi
if [ ! "$(id -g pzombie)" -eq "$GID" ]; then groupmod -o -g "$GID" pzombie ; fi

# Install SteamCMD
if [ ! -f /home/steam/steamcmd.sh ]
then
  echo "Downloading SteamCMD..."
  mkdir -p /home/steam/
  cd /home/steam/
  curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf -
  chown -R pzombie:pzombie /home/steam
  chown -R pzombie:pzombie /data/server-file
fi

# Update pzserver
echo "Updating Project Zomboid..."
if [ "$BRANCH" == "" ]
then
  su pzombie -s /bin/sh -p -c "/home/steam/steamcmd.sh +force_install_dir /data/server-file +login anonymous +app_update 380870 +quit"
else
  su pzombie -s /bin/sh -p -c "/home/steam/steamcmd.sh +force_install_dir /data/server-file +login anonymous +app_update 380870 -beta ${SERVERBRANCH} +quit"
fi

# Symlink
echo "Creating symlink for config folder..."
if [ ! -d /data/config ]
then
  mkdir -p /data/config
fi
su pzombie -s /bin/sh -p -c "ln -s /data/config /home/pzombie/Zomboid"

# Apply server connfiguration
server_ini="/data/config/Server/${SERVER_NAME}.ini"

# create new server.ini
if [ -f $server_ini ]
then
  rm $server_ini
fi

echo "Updating ${SERVER_NAME}.ini..."
mkdir -p /data/config/Server
touch ${server_ini}

echo "DefaultPort=${SERVER_PORT}" >> ${server_ini}
echo "Password=${SERVER_PASSWORD}" >> ${server_ini}
echo "Public=${SERVER_PUBLIC}" >> ${server_ini}
echo "PublicName=${SERVER_PUBLIC_NAME}" >> ${server_ini}
echo "PublicDescription=${SERVER_PUBLIC_DESC}" >> ${server_ini}
echo "RCONPort=${RCON_PORT}" >> ${server_ini}
echo "RCONPassword=${RCON_PASSWORD}" >> ${server_ini}
echo "MaxPlayers=${SERVER_MAX_PLAYER}" >> ${server_ini}
echo "Mods=${MODS}" >> ${server_ini}
echo "WorkshopItems=${WORKSHOP_ITEMS}" >> ${server_ini}
echo "AntiCheatProtectionType1=${ANTICHEAT_PROTECTION_TYPE1}" >> ${server_ini}
echo "AntiCheatProtectionType2=${ANTICHEAT_PROTECTION_TYPE2}" >> ${server_ini}
echo "AntiCheatProtectionType3=${ANTICHEAT_PROTECTION_TYPE3}" >> ${server_ini}
echo "AntiCheatProtectionType4=${ANTICHEAT_PROTECTION_TYPE4}" >> ${server_ini}
echo "AntiCheatProtectionType5=${ANTICHEAT_PROTECTION_TYPE5}" >> ${server_ini}
echo "AntiCheatProtectionType6=${ANTICHEAT_PROTECTION_TYPE6}" >> ${server_ini}
echo "AntiCheatProtectionType7=${ANTICHEAT_PROTECTION_TYPE7}" >> ${server_ini}
echo "AntiCheatProtectionType8=${ANTICHEAT_PROTECTION_TYPE8}" >> ${server_ini}
echo "AntiCheatProtectionType9=${ANTICHEAT_PROTECTION_TYPE9}" >> ${server_ini}
echo "AntiCheatProtectionType10=${ANTICHEAT_PROTECTION_TYPE10}" >> ${server_ini}
echo "AntiCheatProtectionType11=${ANTICHEAT_PROTECTION_TYPE11}" >> ${server_ini}
echo "AntiCheatProtectionType12=${ANTICHEAT_PROTECTION_TYPE12}" >> ${server_ini}
echo "AntiCheatProtectionType13=${ANTICHEAT_PROTECTION_TYPE13}" >> ${server_ini}
echo "AntiCheatProtectionType14=${ANTICHEAT_PROTECTION_TYPE14}" >> ${server_ini}
echo "AntiCheatProtectionType15=${ANTICHEAT_PROTECTION_TYPE15}" >> ${server_ini}
echo "AntiCheatProtectionType16=${ANTICHEAT_PROTECTION_TYPE16}" >> ${server_ini}
echo "AntiCheatProtectionType17=${ANTICHEAT_PROTECTION_TYPE17}" >> ${server_ini}
echo "AntiCheatProtectionType18=${ANTICHEAT_PROTECTION_TYPE18}" >> ${server_ini}
echo "AntiCheatProtectionType19=${ANTICHEAT_PROTECTION_TYPE19}" >> ${server_ini}
echo "AntiCheatProtectionType20=${ANTICHEAT_PROTECTION_TYPE20}" >> ${server_ini}
echo "AntiCheatProtectionType21=${ANTICHEAT_PROTECTION_TYPE21}" >> ${server_ini}
echo "AntiCheatProtectionType22=${ANTICHEAT_PROTECTION_TYPE22}" >> ${server_ini}
echo "AntiCheatProtectionType23=${ANTICHEAT_PROTECTION_TYPE23}" >> ${server_ini}
echo "AntiCheatProtectionType24=${ANTICHEAT_PROTECTION_TYPE24}" >> ${server_ini}
echo "SpawnPoint=${SPAWN_POINT}" >> ${server_ini}

chown -R pzombie:pzombie /data/config/

# Start server
echo "Launching server..."
cd /data/server-file
su pzombie -s /bin/sh -p -c "./start-server.sh -servername ${SERVER_NAME}  -steamport1 ${STEAMPORT1} -steamport2 ${STEAMPORT2} -adminpassword ${SERVER_ADMIN_PASSWORD}"