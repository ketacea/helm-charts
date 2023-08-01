# Docker for Mac

This example deploy a 1 nodes ketadb cluster on [Docker for Mac][] with database for h2
using [custom-values](./values.yaml)

Note that this configuration should be used for test only and isn't recommended
for production.


## Usage

* Deploy ketadb chart with the default values: `make install`

* You can now setup a port forward to query ketadb API:

  ```bash
  kubectl port-forward svc/ketadb-for-mac 9200 -n keta
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