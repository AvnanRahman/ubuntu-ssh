FROM ubuntu:22.04

# Install required packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends dropbear openssh-sftp-server \ 
    nano net-tools wget vim sudo gnupg lsb-release iptables \
    curl apt-transport-https software-properties-common ca-certificates \
    python3 python3-pip python2 && \
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

# Configure dropbear ssh
RUN mkdir -p ./.ssh && \
    chmod 700 ./.ssh && \
    touch ./.ssh/authorized_keys && \
    chmod 600 ./.ssh/authorized_keys && \
    dropbearkey -t rsa -f ./dropbear_rsa_host_key

EXPOSE 5617