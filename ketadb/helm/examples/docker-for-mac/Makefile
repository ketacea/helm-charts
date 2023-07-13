RELEASE := ketadb-for-mac
TIMEOUT := 600s
NAMESPACE := keta

init:
	helm repo add keta-chart http://chart-prod.ketaops.cc --force-update
	helm repo update keta-chart

install: init
	helm upgrade --create-namespace --install --wait --timeout=${TIMEOUT} ${RELEASE} -n ${NAMESPACE} --values values.yaml ../../ 

forward:
	kubectl port-forward svc/${RELEASE} 9200 -n keta

uninstall:
	helm del ${RELEASE} -n ${NAMESPACE}

purge:
	kubectl delete ns ${NAMESPACE}

status:
	helm list -n ${NAMESPACE}
	@echo 
	kubectl get pod -n ${NAMESPACE}