FROM ubuntu:22.04

# Install required packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends dropbear openssh-sftp-server \ 
    nano net-tools wget vim sudo gnupg lsb-release systemd iptables \
    curl apt-transport-https software-properties-common ca-certificates \
    python3 python3-pip python2 \
    dbus-user-session fuse-overlayfs iproute2 uidmap fuse3 slirp4netns && \
    apt-get clean

# Add Docker's official GPG key and repository
RUN mkdir -m 0755 -p /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list

# Install Docker binaries
RUN apt-get update && apt-get install -y --no-install-recommends docker-ce docker-ce-cli docker-ce-rootless-extras && \
    apt-get clean

# Create user
ARG USER_NAME=ubuntu
ARG USER_ID=1000
ARG GROUP_NAME=$USER_NAME
ARG GROUP_ID=$USER_ID
ARG HOME=/home/$USER_NAME

RUN groupadd --gid $GROUP_ID $GROUP_NAME && \
    useradd --uid $USER_ID --gid $GROUP_ID --create-home $USER_NAME && \
    echo "$USER_NAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER $USER_NAME
WORKDIR $HOME

# Install Docker-compose
RUN mkdir -p ./.docker/cli-plugins/ && \
    curl -SL https://github.com/docker/compose/releases/download/v2.3.3/docker-compose-$(uname -s)-$(uname -m) -o ./.docker/cli-plugins/docker-compose && \
    chmod +x ./.docker/cli-plugins/docker-compose

# Configure dropbear ssh
RUN mkdir -p ./.ssh && \
    chmod 700 ./.ssh && \
    touch ./.ssh/authorized_keys && \
    chmod 600 ./.ssh/authorized_keys && \
    dropbearkey -t rsa -f ./dropbear_rsa_host_key

EXPOSE 5617