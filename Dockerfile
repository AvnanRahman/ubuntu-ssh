FROM ubuntu:22.04

# Install necessary packages
RUN apt-get update && apt-get install -y \
    openssh-server sudo nano net-tools && \
    rm -rf /var/lib/apt/lists/*

# Configure SSH server and non-root user
RUN useradd -m -s /bin/bash ubuntu && echo "ubuntu:password" | chpasswd && \
    mkdir /home/ubuntu/.ssh && \
    chmod 700 /home/ubuntu/.ssh && \
    echo "ubuntu ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
    mkdir -p /run/sshd && \
    sed -i 's/^#Port 22/Port 5617/' /etc/ssh/sshd_config && \
    sed -i 's/^#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config && \
    sed -i 's/^#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    echo "HostKey /etc/ssh/ssh_host_rsa_key" >> /etc/ssh/sshd_config && \
    echo "HostKey /etc/ssh/ssh_host_ecdsa_key" >> /etc/ssh/sshd_config && \
    echo "HostKey /etc/ssh/ssh_host_ed25519_key" >> /etc/ssh/sshd_config

# Generate SSH host keys manually
RUN rm -f /etc/ssh/ssh_host_* && \
    mkdir -p /etc/ssh && \
    ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N '' && \
    ssh-keygen -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key -N '' && \
    ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key -N '' && \
    chmod 600 /etc/ssh/ssh_host_* && \
    chown ubuntu:ubuntu /etc/ssh/ssh_host_*

# Change ownership of SSH-related files to the non-root user
RUN chown -R ubuntu:ubuntu /home/ubuntu/.ssh

# Switch to non-root user
USER ubuntu

# Expose the SSH port
EXPOSE 5617

# Start SSH server
CMD ["/usr/sbin/sshd", "-D"]