PREFIX := ketadb
TIMEOUT := 600s
NAMESPACE := keta
MYSQL_PASSWORD := password123
MYSQL_RELEASE := mysql

init:
	helm repo add keta-chart http://chart-prod.ketaops.cc --force-update
	helm repo update keta-chart

install: init
	helm upgrade --create-namespace --install --wait --timeout=${TIMEOUT} -n ${NAMESPACE} ${MYSQL_RELEASE} keta-chart/mysql --set auth.rootPassword="${MYSQL_PASSWORD}"
	helm upgrade --create-namespace --install --wait --timeout=${TIMEOUT} -n ${NAMESPACE} ${PREFIX}-master --values master.yaml ../../ --set mysql.password="${MYSQL_PASSWORD}" --set mysql.host=${MYSQL_RELEASE}
	helm upgrade --create-namespace --install --wait --timeout=${TIMEOUT} -n ${NAMESPACE} ${PREFIX}-web --values web.yaml ../../ --set mysql.password="${MYSQL_PASSWORD}" --set mysql.host=${MYSQL_RELEASE}
	helm upgrade --create-namespace --install --wait --timeout=${TIMEOUT} -n ${NAMESPACE} ${PREFIX}-data --values data.yaml ../../ --set mysql.password="${MYSQL_PASSWORD}" --set mysql.host=${MYSQL_RELEASE}

uninstall:
	helm del ${PREFIX}-data -n ${NAMESPACE}
	helm del ${PREFIX}-web -n ${NAMESPACE}
	helm del ${PREFIX}-master -n ${NAMESPACE}
	helm del ${MYSQL_RELEASE} -n ${NAMESPACE}

purge:
	kubectl delete ns ${NAMESPACE}