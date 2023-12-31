# Docker for Mac

This example deploy an ketadb cluster composed of 3 different Helm releases:

* ketadb-master for the 1 master nodes using [master values](./master.yaml)
* ketadb-data for the 1 data nodes using [data values](./data.yaml)
* ketadb-web for the 1 client nodes using [web values](./web.yaml)


## Usage

* Deploy ketadb chart with the default values: `make install`

* You can now setup a port forward to query ketadb API:

  ```bash
  kubectl port-forward svc/ketadb-web 9200 -n keta
  open http://localhost:9200
  ```

* Clean up the environment and data.
  ```bash
  # delete release
  make uninstall
  # delete namespace
  make purge
  ```

[docker for mac]: https://docs.docker.com/docker-for-mac/kubernetes/