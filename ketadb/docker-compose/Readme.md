# Deployment Instructions
## Prerequisites
1. Install [docker](https://docs.docker.com/engine/install/)
2. Install [docker-compose](https://docs.docker.com/compose/install/standalone/)

## Limitations
1. Linux amd64 machine.
2. Requires external network access (If not available, offline image usage is required).
3. This method only supports single-node deployment (can have multiple nodes on a single machine).

## Installation Steps
1. Place this directory (docker-compose) under the deployment directory, e.g., ~/docker-compose.
2. Execute the installation steps:
    ```bash
    cd ~/docker-compose
    docker-compose up -d
    # Check installation status
    docker-compose ps
    # View logs
    docker-compose logs -f ketadb
    ```

## Custom Configuration
The `.env` file contains configurable options for deployment.

1. Use custom storage paths:
    ```bash
    ...
    # Persistence configuration
    MYSQL_DATA_PATH=./mysql-data
    KETADB_DATA_PATH=./keta-data
    ...
    ```

2. Customize external access ports:
    ```bash
    ...
    # Web page port
    KETADB_WEB_PORT=9200
    # Cluster discovery port, needs to be open for other machines when assembling multiple nodes
    KETADB_UNICAST_PORT=9300
    # keta-agent connection port
    KETADB_TANSPORT_PORT=9400
    # SPL search RPC port
    KETADB_SEARCH_RPC_PORT=9500
    ...
    ```

3. Others:
    ```bash
    # Docker repository address
    REPOSITORY=docker.ketaops.cc

    # Docker image address
    KETADB_IMAGE_IMAGE=ketaops/ketadb
    KETA_ML_IMAGE_IMAGE=ketaops/ketadb

    # Docker image tag
    KETADB_IMAGE_TAG=v1.2.1.1
    KETA_ML_IMAGE_TAG=v1.2.1.1

    # JVM OPTIONS
    JVM_OPTIONS="-Xmx2g -Xms2g"

    ```
