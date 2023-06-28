# Docker for Mac

This example deploy a 1 nodes ketadb cluster on [Docker for Mac][]
using [custom-values](./values.yaml)

Note that this configuration should be used for test only and isn't recommended
for production.


## Usage

* Deploy Elasticsearch chart with the default values: `make install`

* You can now setup a port forward to query Elasticsearch API:

  ```bash
  kubectl port-forward svc/ketadb-for-mac 9200 -n keta
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