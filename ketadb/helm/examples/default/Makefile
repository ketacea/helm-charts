RELEASE := ketadb-default
TIMEOUT := 600s
NAMESPACE := keta

install:
	helm upgrade --create-namespace --install --wait --timeout=${TIMEOUT} ${RELEASE} ../../ -n ${NAMESPACE}

uninstall:
	helm del ${RELEASE} -n ${NAMESPACE}

pruge:
	kubectl delete ns ${NAMESPACE}