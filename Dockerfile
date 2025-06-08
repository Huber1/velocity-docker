FROM docker.io/eclipse-temurin:21-jre

ARG DOWNLOAD_URL

# download paperclip
ADD "${DOWNLOAD_URL}" /opt/velocity/velocity.jar

# add rcon-cli
COPY --from=docker.io/itzg/rcon-cli:latest /rcon-cli /usr/local/bin/rcon-cli

# install dependencies
RUN apt update && apt install -y gosu webp adduser netcat-openbsd && apt clean && rm -rf /var/lib/apt/lists/*

# Expose minecraft port
EXPOSE 25565/tcp 25565/udp

# define environment variables
ENV JAVAFLAGS="-XX:+UseG1GC -XX:G1HeapRegionSize=4M -XX:+UnlockExperimentalVMOptions -XX:+ParallelRefProcEnabled -XX:+AlwaysPreTouch -XX:MaxInlineLevel=15"
ENV VELOCITY_FLAG=""

# ENV MEMORYSIZE="1G"
# Memory Management Notes:
# - Use container runtime memory limits (--memory flag)
# - Java will automatically detect container memory with -XX:+UseContainerSupport
# Recommended reading: https://www.ibm.com/docs/en/sdk-java-technology/8?topic=options-xx-usecontainersupport

VOLUME /data

WORKDIR /data

COPY /docker-entrypoint.sh /opt/velocity

RUN chmod -R a+rw /opt/velocity && chmod -R a+rw /data/

ENTRYPOINT ["/opt/velocity/docker-entrypoint.sh"]

HEALTHCHECK --interval=30s --timeout=5s --start-period=3m CMD nc -z 127.0.0.1 25565 || exit 1
