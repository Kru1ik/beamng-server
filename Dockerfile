# Use Ubuntu as base image
FROM ubuntu:latest
# Update package lists and install SSH server and fail2ban
RUN apt-get update && \
    apt-get install -y openssh-server fail2ban && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
# Copy custom fail2ban configuration
COPY jail.local /etc/fail2ban/jail.local

# Set the working directory
WORKDIR /home/beammpserver
# At this point, you need to have the BeamMP-Server file inside the Docker context and copy it into the image.
# If you have a direct download link, you could use `wget` to download it instead of the COPY command.
COPY BeamMP-Server.ubuntu.22.04.x86_64 /home/beammpserver/BeamMP-Server

# Copy entrypoint
COPY entrypoint.sh /entrypoint.sh

# OR, for an example with wget (replace `your_direct_download_link` with the actual URL):
# RUN wget -O BeamMP-Server your_direct_download_link
# Make the server executable
RUN chmod +x BeamMP-Server
RUN chmod +x /entrypoint.sh

# Expose SSH port
EXPOSE 22

# Expose port 30814 for your other application
EXPOSE 30814

# Set entrypoint
ENTRYPOINT ["/entrypoint.sh"]
