# Default

This example deploy a 3 nodes ketadb cluster using
[default-values](../../values.yaml).


## Usage

* Deploy ketadb chart with the default values: `make install`

* You can now setup a port forward to query ketadb API:

  ```
  kubectl port-forward svc/ketadb-default 9200 -n keta

  # visit for web
  open http://localhost:9200
  ```

* Clean up the environment and data.
  ```bash
  # delete release
  make uninstall
  # delete namespace
  make purge
  ```