FROM ubuntu:22.04

RUN apt-get update && \
    apt-get install -y --no-install-recommends dropbear openssh-sftp-server nano net-tools curl wget vim sudo python3 python3-pip python2 && \
    apt-get clean

ARG USER_NAME=ubuntu
ARG USER_ID=1000
ARG GROUP_NAME=$USER_NAME
ARG GROUP_ID=$USER_ID
ARG HOME=/home/$USER_NAME

RUN groupadd --gid $GROUP_ID $GROUP_NAME && \
    useradd --uid $USER_ID --gid $GROUP_ID --create-home --shell /bin/bash --no-log-init $USER_NAME

USER $USER_NAME

WORKDIR $HOME

RUN mkdir -p ./.ssh && \
    chmod 700 ./.ssh && \
    touch ./.ssh/authorized_keys && \
    chmod 600 ./.ssh/authorized_keys && \
    dropbearkey -t rsa -f ./dropbear_rsa_host_key

EXPOSE 5617