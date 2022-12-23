#!/bin/bash
while true; do
  # Check if the Docker service is available
  if ! ls /var/run/docker.sock &> /dev/null; then
    # If the Docker service is not available, print an error message
    >&2 echo "Error: Docker service is not available"
    exit 1
  fi

  echo "Checking for unhealthy containers"
  set -e

  # Get the names of all unhealthy containers
  unhealthy_containers=$(docker ps --filter "health=unhealthy" | tail -n +2 | awk '{print $NF}')

  # Restart each unhealthy container and send a message to Telegram
  for container in $unhealthy_containers; do
    # Restart the container and check the exit code
    if ! docker restart "$container"; then
      # If the restart command fails, print an error message
      >&2 echo "Error: Failed to restart container $container"
      curl -s -X POST "https://api.telegram.org/bot$BOT_API_KEY/sendMessage" -d chat_id=$CHAT_ID -d parse_mode="Markdown" -d text="*$HOST_ALIAS*%0AAn unhealthy container has been found but cant be restarted: $container"
    else
      echo "The Container $container was restarted"
      curl -s -X POST "https://api.telegram.org/bot$BOT_API_KEY/sendMessage" -d chat_id=$CHAT_ID -d parse_mode="Markdown" -d text="*$HOST_ALIAS*%0AAn unhealthy container has been restarted: $container"
    fi
  done

  # If no unhealthy containers were found, print a message
  if [ -z "$unhealthy_containers" ]; then
    echo "All containers are healthy"
  fi
  sleep 600
done