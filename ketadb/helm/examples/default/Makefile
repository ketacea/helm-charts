RELEASE := ketadb-default
TIMEOUT := 600s
NAMESPACE := keta
MYSQL_PASSWORD := "password123"

init:
	helm repo add keta-chart http://chart-prod.ketaops.cc --force-update
	helm repo update keta-chart

install: init
	helm upgrade --create-namespace --install --wait --timeout=${TIMEOUT} -n ${NAMESPACE} ${MYSQL_RELEASE} keta-chart/mysql --set auth.rootPassword=${MYSQL_PASSWORD} 
	helm upgrade --create-namespace --install --wait --timeout=${TIMEOUT} -n ${NAMESPACE} ${RELEASE} ../../ --set mysql.password=${MYSQL_PASSWORD}

uninstall:
	helm del ${RELEASE} -n ${NAMESPACE}

pruge:
	kubectl delete ns ${NAMESPACE}