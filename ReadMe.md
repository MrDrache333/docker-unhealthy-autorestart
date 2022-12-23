# Automatically restart unhealthy docker containers
[![Create and publish Docker image](https://github.com/MrDrache333/docker-unhealthy-autorestart/workflows/Create%20and%20publish%20Docker%20image/badge.svg)](https://github.com/MrDrache333/docker-unhealthy-autorestart/actions?query=workflow:"Create+and+publish+Docker+image")
[![GitHub release](https://img.shields.io/github/release/MrDrache333/docker-unhealthy-autorestart?include_prereleases=&sort=semver&color=blue)](https://github.com/MrDrache333/docker-unhealthy-autorestart/releases/)
[![License](https://img.shields.io/badge/License-MIT-blue)](#license)
[![issues - docker-unhealthy-autorestart](https://img.shields.io/github/issues/MrDrache333/docker-unhealthy-autorestart)](https://github.com/MrDrache333/docker-unhealthy-autorestart/issues)

This script is designed to monitor the health of Docker containers and automatically restart any unhealthy containers.
It also sends a notification to a Telegram chat when a container is restarted.

## Prerequisites

- Docker must be installed on the host machine.
- A Telegram bot must be created and the `BOT_API_KEY` and `CHAT_ID` must be obtained.

## Installation

Replace `BOT_API_TOKEN` with the API key for your Telegram bot and `YOUR_CHAT_ID` with the ID of the Telegram chat to
send notifications to. You can also specify a friendly name for the host machine using the `HOST_ALIAS` variable.

The volumes section of the docker-compose.yml file mounts the host machine's Docker socket as a volume in the container.
This allows the script to access the Docker daemon and manage the containers on the host machine.

To start the container, run the following command:

```
docker-compose up -d
```

This will pull the mrdrache333/unhealthy-autostart image from Docker Hub and start the container in the background. The
script will run automatically when the container starts, and it will continue running in the background until the
container is stopped.

## Environment Variables

### BOT_API_KEY

The BOT_API_KEY is the API token for your bot, which is used to authenticate the bot and authorize it to perform actions
on behalf of your account.

### CHAT_ID

The CHAT_ID is the unique identifier for the chat or group where you want the bot to send notifications.

### HOST_ALIAS

The HOST_ALIAS is an optional field that allows you to specify a custom alias for the host where the bot is running.
This alias will be used in the notifications sent by the bot.

### BLACKLIST

The BLACKLIST is an optional field that allows you to specify a list of containers that will not be restarted by the
bot. The list should be a space-separated string of container names.

### NOTIFY_BLACKLIST

The NOTIFY_BLACKLIST is an optional field that allows you to specify a list of containers that will be restarted by the
bot, but without sending a notification

## Usage

To stop the container, run the following command:

```
docker-compose down
```

To view the logs of the script, use the following command:

```
docker-compose logs
```

## License

This project is licensed under the MIT License.
