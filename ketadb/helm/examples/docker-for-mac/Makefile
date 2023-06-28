RELEASE := ketadb-for-mac
TIMEOUT := 600s
NAMESPACE := keta

install:
	helm upgrade --create-namespace --install --wait --timeout=${TIMEOUT} ${RELEASE} -n ${NAMESPACE} --values values.yaml ../../ 

uninstall:
	helm del ${RELEASE} -n ${NAMESPACE}

pruge:
	kubectl delete ns ${NAMESPACE}