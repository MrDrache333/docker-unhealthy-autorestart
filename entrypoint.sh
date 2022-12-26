#!/bin/bash
# Check if BOT_API_KEY is set
if [ -z "$BOT_API_KEY" ]; then
  # If not set, print an error message
  echo "Error: BOT_API_KEY is not set. This variable is used to authenticate with the bot API. Please set this variable before running the script."
  # Exit with a non-zero exit code to indicate an error
  exit 1
fi

# Check if CHAT_ID is set
if [ -z "$CHAT_ID" ]; then
  # If not set, print an error message
  echo "Error: CHAT_ID is not set. This variable is used to specify the chat to send messages to. Please set this variable before running the script."
  # Exit with a non-zero exit code to indicate an error
  exit 1
fi

# Check if HOST_ALIAS is set
if [ -z "$HOST_ALIAS" ]; then
  # If not set, print an error message
  echo "Error: HOST_ALIAS is not set. This variable is used to specify the alias of the host. Please set this variable before running the script."
  # Exit with a non-zero exit code to indicate an error
  exit 1
fi

# Check if START_MESSAGE is set
if "$START_MESSAGE" = "true" ; then
  curl -s -X POST "https://api.telegram.org/bot$BOT_API_KEY/sendMessage" -d chat_id="$CHAT_ID" -d parse_mode="Markdown" -d text="*$HOST_ALIAS*%0AWatchdog started!"
else
  echo "Container started."
fi

# Load env variables
blacklist=${BLACKLIST:-}
notify_blacklist=${NOTIFY_BLACKLIST:-}

# Check variables for presence and set default if not
if [[ -z $blacklist ]]; then
  blacklist=()
else
  IFS=' ' read -r -a blacklist <<< "$blacklist"
  echo "Blacklisted Containers:"
  printf '%s\n' "${blacklist[@]}"
fi
if [[ -z $notify_blacklist ]]; then
  notify_blacklist=()
else
  IFS=' ' read -r -a notify_blacklist <<< "$notify_blacklist"
  echo "Blacklisted Notifications:"
  printf '%s\n' "${notify_blacklist[@]}"
fi

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
    # Skip blacklisted containers
    if [[ "${blacklist[*]}" == *"$container"* ]]; then
      echo "The unhealthy Container $container was skipped"
      continue
    fi
    # Restart the container and check the exit code
    if ! docker restart "$container"; then
      >&2 echo "Error: Failed to restart container $container"
      if [[ "${notify_blacklist[*]}" == *"$container"* ]]; then
        # If the restart command fails, print an error message
        curl -s -X POST "https://api.telegram.org/bot$BOT_API_KEY/sendMessage" -d chat_id="$CHAT_ID" -d parse_mode="Markdown" -d text="*$HOST_ALIAS*%0AAn unhealthy container has been found but cant be restarted: $container"
      fi
    else
      echo "The Container $container was restarted"
      if [[ "${notify_blacklist[*]}" == *"$container"* ]]; then
        curl -s -X POST "https://api.telegram.org/bot$BOT_API_KEY/sendMessage" -d chat_id="$CHAT_ID" -d parse_mode="Markdown" -d text="*$HOST_ALIAS*%0AAn unhealthy container has been restarted: $container"
      fi
    fi
  done

  # If no unhealthy containers were found, print a message
  if [ -z "$unhealthy_containers" ]; then
    echo "All containers are healthy"
  fi
  sleep 600
done