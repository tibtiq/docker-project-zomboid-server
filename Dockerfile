FROM ubuntu:22.04

# Env var
ENV STEAMPORT1="8766" \
    STEAMPORT2="8767" \
    SERVER_NAME="server" \
    SERVER_PASSWORD="" \
    SERVER_ADMIN_PASSWORD="pzadmin" \
    SERVER_PORT="16261" \
    SERVER_BRANCH="" \
    SERVER_PUBLIC="false" \
    SERVER_PUBLIC_NAME="Project Zomboid Docker Server" \
    SERVER_PUBLIC_DESC="" \
    SERVER_MAX_PLAYER="16" \
    RCON_PORT="27015" \
    RCON_PASSWORD="" \
    MODS="" \
    WORKSHOP_ITEMS="" \
    ANTICHEAT_PROTECTION_TYPE1="true" \
    ANTICHEAT_PROTECTION_TYPE2="true" \
    ANTICHEAT_PROTECTION_TYPE3="true" \
    ANTICHEAT_PROTECTION_TYPE4="true" \
    ANTICHEAT_PROTECTION_TYPE5="true" \
    ANTICHEAT_PROTECTION_TYPE6="true" \
    ANTICHEAT_PROTECTION_TYPE7="true" \
    ANTICHEAT_PROTECTION_TYPE8="true" \
    ANTICHEAT_PROTECTION_TYPE9="true" \
    ANTICHEAT_PROTECTION_TYPE10="true" \
    ANTICHEAT_PROTECTION_TYPE11="true" \
    ANTICHEAT_PROTECTION_TYPE12="true" \
    ANTICHEAT_PROTECTION_TYPE13="true" \
    ANTICHEAT_PROTECTION_TYPE14="true" \
    ANTICHEAT_PROTECTION_TYPE15="true" \
    ANTICHEAT_PROTECTION_TYPE16="true" \
    ANTICHEAT_PROTECTION_TYPE17="true" \
    ANTICHEAT_PROTECTION_TYPE18="true" \
    ANTICHEAT_PROTECTION_TYPE19="true" \
    ANTICHEAT_PROTECTION_TYPE20="true" \
    ANTICHEAT_PROTECTION_TYPE21="true" \
    ANTICHEAT_PROTECTION_TYPE22="true" \
    ANTICHEAT_PROTECTION_TYPE23="true" \
    ANTICHEAT_PROTECTION_TYPE24="true" \
    SPAWN_POINT="0,0,0" \
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
EXPOSE $SERVER_PORT/udp
EXPOSE ${RCON_PORT}

VOLUME ["/data/server-file", "/data/config"]

COPY entry.sh /data/scripts/entry.sh
CMD ["bash", "/data/scripts/entry.sh"]
