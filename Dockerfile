FROM alpine:edge

LABEL maintainer "Vadim Delendik <vdelendik@zebrunner.com>"

ENV DEBIAN_FRONTEND=noninteractive

#=============
# Set WORKDIR
#=============
WORKDIR /root

# Set up insecure default key
RUN mkdir -m 0750 /root/.android
ADD files/insecure_shared_adbkey /root/.android/adbkey
ADD files/insecure_shared_adbkey.pub /root/.android/adbkey.pub

#==================
# General Packages
#==================
RUN apk add --no-cache \
    bash \
    curl \
    bind-tools

# ADB part
RUN apk add \
    android-tools \
    --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing

# Expose default ADB port
EXPOSE 5037

## Hook up tini as the default init system for proper signal handling
#ENTRYPOINT ["/bin/bash", "--"]

# Start the server by default
CMD ["adb", "-a", "-P", "5037", "server", "nodaemon"]
