RELEASE := ketadb-for-mac
TIMEOUT := 600s
NAMESPACE := keta

init:
	helm repo add keta-chart http://chart-prod.ketaops.cc --force-update
	helm repo update keta-chart

install: init
	helm upgrade --create-namespace --install --wait --timeout=${TIMEOUT} ${RELEASE} -n ${NAMESPACE} --values values.yaml ../../ 

uninstall:
	helm del ${RELEASE} -n ${NAMESPACE}

pruge:
	kubectl delete ns ${NAMESPACE}