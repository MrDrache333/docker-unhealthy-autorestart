# Automatically restart unhealthy docker containers

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