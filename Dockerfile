FROM alpine:latest

# Install bash, curl, docker.io, and cron
RUN apk add bash curl docker docker-cli cronie

# Add the entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Create cron job file
RUN touch /etc/cron.d/crontab
# Make cron job file executable
RUN chmod 0644 /etc/cron.d/crontab
# Create cronjob
RUN echo "0 0 * * * /entrypoint.sh" > /etc/cron.d/crontab
# Install cronjob
RUN crontab /etc/cron.d/crontab
# Create logfile for cronjob
RUN touch /var/log/cron.log
USER root
# Set the entrypoint
ENTRYPOINT ["/entrypoint.sh"]
