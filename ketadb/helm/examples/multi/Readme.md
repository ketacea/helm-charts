# Docker for Mac

This example deploy an Elasticsearch 8.5.1 cluster composed of 3 different Helm releases:

* ketadb-multi-master for the 3 master nodes using [master values](./master.yaml)
* ketadb-multi-data for the 3 data nodes using [data values](./data.yaml)
* ketadb-multi-web for the 3 client nodes using [web values](./web.yaml)


## Usage

* Deploy Elasticsearch chart with the default values: `make install`

* You can now setup a port forward to query Elasticsearch API:

  ```bash
  kubectl port-forward svc/ketadb-web 9200 -n keta
  open localhost:9200
  ```

* Clean up the environment and data.
  ```bash
  # delete release
  make uninstall
  # delete namespace
  make pruge
  ```

[docker for mac]: https://docs.docker.com/docker-for-mac/kubernetes/