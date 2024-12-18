FROM nvidia/cuda:12.4.1-cudnn-devel-ubuntu22.04

# Install required packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends dropbear openssh-sftp-server \ 
    nano net-tools wget vim sudo gnupg lsb-release iptables git python2 \
    curl apt-transport-https software-properties-common ca-certificates \
    build-essential zlib1g-dev libffi-dev libssl-dev libbz2-dev libreadline-dev \
    libsqlite3-dev libncurses5-dev libgdbm-dev libnss3-dev liblzma-dev && \ 
    apt-get clean

# Download and install Python 3.11.5
RUN wget https://www.python.org/ftp/python/3.11.5/Python-3.11.5.tgz && \
    tar -xvf Python-3.11.5.tgz && \
    cd Python-3.11.5 && \
    ./configure --enable-optimizations && \
    make && \
    sudo make install && \
    cd .. && rm -rf Python-3.11.5 Python-3.11.5.tgz

# Set Python 3.11 and 2 the default python
RUN sudo update-alternatives --install /usr/bin/python3 python3 /usr/local/bin/python3.11 1 && \
    sudo update-alternatives --install /usr/bin/python python /usr/bin/python2 2 && \
    echo 1 | sudo update-alternatives --config python3 && \
    python3 --version

# Install pip for Python 3.11
RUN curl -sS https://bootstrap.pypa.io/get-pip.py | python3 && \
    python3 -m pip install --upgrade pip setuptools && \
    pip --version

# Install venv module for Python 3.11
RUN python3 -m ensurepip && \
    python3 -m pip install virtualenv && \
    python3 -m venv /opt/venv

# Create user
ARG USER_NAME=ubuntu
ARG USER_ID=1000
ARG GROUP_NAME=$USER_NAME
ARG GROUP_ID=$USER_ID
ARG HOME=/home/$USER_NAME

RUN groupadd --gid $GROUP_ID $GROUP_NAME && \
    useradd --uid $USER_ID --gid $GROUP_ID --create-home --shell /bin/bash --no-log-init $USER_NAME && \
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