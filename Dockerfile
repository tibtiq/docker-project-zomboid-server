FROM ubuntu:22.04

# Env var
ENV STEAMPORT1="8766" \
    STEAMPORT2="8767" \
    SERVER_NAME="server" \
    SERVER_ADMIN_PASSWORD="pzadmin" \
    DefaultPort="16261" \
    SERVER_BRANCH="" \
	UID="1000" \
	GID="1000"

# Install dependencies
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
        lib32gcc-s1 \
        curl \
        default-jre \
    && apt-get clean autoclean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*

# Add User
RUN useradd -u ${UID} -U -m -s /bin/false pzombie && usermod -G users pzombie

# Expose ports
EXPOSE $STEAMPORT1/udp
EXPOSE $STEAMPORT2/udp
EXPOSE $DefaultPort/udp
EXPOSE ${RCON_PORT}

# add default spawn locations from hosting server through steam
COPY server_spawnregions.lua /data/config/Server/server_spawnregions.lua

COPY /res/default_settings.txt /scripts/default_settings.txt

COPY entry.sh /scripts/entry.sh
CMD ["bash", "/scripts/entry.sh"]
