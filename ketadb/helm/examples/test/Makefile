RELEASE := ketadb-test
MYSQL_RELEASE := mysql
TIMEOUT := 600s
NAMESPACE := keta

init:
	helm repo add keta-chart http://chart-prod.ketaops.cc --force-update
	helm repo update keta-chart

install: init
	helm upgrade --create-namespace --install --wait --timeout=${TIMEOUT} -n ${NAMESPACE} ${MYSQL_RELEASE} --values mysql.yaml keta-chart/mysql
	helm upgrade --create-namespace --install --wait --timeout=${TIMEOUT} -n ${NAMESPACE} ${RELEASE} --values values.yaml --set mysql.host=${MYSQL_RELEASE} ../../ 

uninstall:
	helm del ${RELEASE} -n ${NAMESPACE}

pruge:
	kubectl delete ns ${NAMESPACE}