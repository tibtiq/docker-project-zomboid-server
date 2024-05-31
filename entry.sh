#!/bin/bash

# Ensure User and Group IDs
if [ ! "$(id -u pzombie)" -eq "$UID" ]; then usermod -o -u "$UID" pzombie; fi
if [ ! "$(id -g pzombie)" -eq "$GID" ]; then groupmod -o -g "$GID" pzombie; fi

# Install SteamCMD
if [ ! -f /home/steam/steamcmd.sh ]; then
  echo "Downloading SteamCMD..."
  mkdir -p /home/steam/
  cd /home/steam/
  curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf -
  chown -R pzombie:pzombie /home/steam
  mkdir -p /data/server-file
  chown -R pzombie:pzombie /data/server-file
fi

# Update pzserver
echo "Updating Project Zomboid..."
if [ "$SERVER_BRANCH" == "" ]; then
  su pzombie -s /bin/sh -p -c "/home/steam/steamcmd.sh +force_install_dir /data/server-file +login anonymous +app_update 380870 +quit"
else
  su pzombie -s /bin/sh -p -c "/home/steam/steamcmd.sh +force_install_dir /data/server-file +login anonymous +app_update 380870 -beta ${SERVERBRANCH} +quit"
fi

# Symlink
echo "Creating symlink for config folder..."
if [ ! -d /data/config ]; then
  mkdir -p /data/config
fi
su pzombie -s /bin/sh -p -c "ln -s /data/config /home/pzombie/Zomboid"

# Apply server connfiguration
server_ini="/data/config/Server/${SERVER_NAME}.ini"

# create new server.ini
if [ -f $server_ini ]; then
  rm $server_ini
fi

echo "Updating ${SERVER_NAME}.ini..."
mkdir -p /data/config/Server
touch ${server_ini}

default_settings_path="/scripts/default_settings.txt"
while read line; do
  # split setting name and default value
  IFS='=' read -r -a setting_pair <<<"$line"
  setting_name="${setting_pair[0]}"
  setting_default_value="${setting_pair[1]}"

  # check if there isn't a variable with matching setting name
  if [ -z "${!setting_name}" ]; then
    # use default value
    echo "${setting_name}=${setting_default_value}" >>$server_ini
  else
    # use docker compose environment variable value
    echo "${setting_name}=${!setting_name}" >>$server_ini
  fi
done <$default_settings_path

chown -R pzombie:pzombie /data/config/

# Start server
echo "Launching server..."
cd /data/server-file
su pzombie -s /bin/sh -p -c "./start-server.sh -servername ${SERVER_NAME}  -steamport1 ${STEAMPORT1} -steamport2 ${STEAMPORT2} -adminpassword ${SERVER_ADMIN_PASSWORD}"
