## Self-hosted docker compose framework v 0.1.0

### Introduction
* This repo is a sample framework that should cover best practices for docker compose usage.
* This is my own evolution of using docker compose on a single server for self-hosting apps. It is my own experience, and it might not fit everyone's needs, however hopefully it will have some `good ideas` for everyone to use.
* There is a root level `docker-compose.yaml` file that imports each app's `docker-compose.yaml`.

### Requirements
* Your docker version should be >= `2.20.3`. This is when [include](https://docs.docker.com/compose/multiple-compose-files/include/) was introduced.

### Getting started:
* Search for the text: `##SETUP` to replace few placeholders with your own values.

### Common environment variables
* The root level docker-compose also defines a set of predefined environment variables:
  * `DOCKER_COMPOSE_TZ`: Timezone
  * `DOCKER_COMPOSE_PUID` and `DOCKER_COMPOSE_PGID` that match the system's settings for user and group ID to be used inside containers.
  * `DOCKER_COMPOSE_RESTART_VALUE`: The default restart value.
  * `DOCKER_COMPOSE_VOLUMES_ROOT`: The root level for volumes, you need to set this up.
  * `DOCKER_COMPOSE_STATEFUL_VOLUMES_ROOT`: This is the directory for volumes that needs backups.
  * `DOCKER_COMPOSE_STATEFUL_LOCKED_VOLUMES_ROOT`: This is also a directory of volumes that needs backup, but containers should be stopped before backing this up. Example: databases such as postgres need to be stopped before copying the files.
  * `DOCKER_COMPOSE_STATELESS_VOLUMES_ROOT`: This is the directory for volumes that do not need to be backed up, usually things like cache that when deleted do not affect the state of your apps.
  * A set of env variables that define memory limits: `DOCKER_COMPOSE_MEM_LIMIT_*`. Please check the `.env` file for the full list.
  * A set of env variables that define CPU limits: `DOCKER_COMPOSE_CPU_*`. Please check the `.env` file for the full list.

### Anatomy of an individual app
* The individual app docker compose setup: 
  * There is a predefined `common` section at the top that makes use of the common environment variables. Use this to define common env variables, restart mode, memory and CPU limits.
  * Defining individual memory and CPU limits on containers is a good practice for the stability of your server.
  * Defining the service(s):
    * Start by including the common section always
    * Always specify the container name
    * Specify the expose as a way to self document what this container exposes. If you are using a reverse proxy then you don't need to expose ports to your host machine. If you are defining mapped ports then expose is not needed.
    * Try to define the properties for your services in alphabetical order to retain a common familiar order across all setups.
      * for example `container_name` comes before `expose`. `c` before `e`
    * Use the `main-network` always unless the app has the need to define its own network for one reason or another.
    * Define other networks within the apps that need them.
    * Depending on what dashboard you are using, you may want to define some labels.

### The default setup
* The default setup includes
  * `sample-app`: This is your template for adding more apps. Each app lives in its own folder.
  * `dozzle`: Is always a good idea to have so you can check containers metrics/logs at a glance.
  * `watchtower`: Is defined to allow the auto update of some containers, some people prefer not to use it, in this case you can just delete the folder.

### Folder structure
* This is the suggested folder structure
* Pick your own user root docker folder and under it, create this structure:
```
/[USER ROOT DOCKER FOLDER]
 ├── 🗁 selfhosted-docker-compose-framework/
     ├── 🗋 docker-compose.yml
     ├── 🗋 .env
     ├── 🗋 apps/
     └── (this is this repo)/
 ├── 🗁 volumes/                     
     ├── 🗁 stateful/                (need to backup)
     ├── 🗁 stateful-locked/         (need to backup, but containers must be stopped)
     └── 🗁 stateless/               (no need to backup)
```

### Make commands
* `make update`: pulls latest, builds and redeploys.
* `make trivy`: Runs [trivy](https://github.com/aquasecurity/trivy). This is a security scanner.