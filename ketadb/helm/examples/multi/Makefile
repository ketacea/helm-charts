PREFIX := ketadb
TIMEOUT := 600s
NAMESPACE := keta
MYSQL_PASSWORD := changeYourPassword
MYSQL_RELEASE := mysql

init:
	helm repo add keta-chart http://chart-prod.ketaops.cc --force-update
	helm repo update keta-chart

install: init
	helm upgrade --create-namespace --install --wait --timeout=${TIMEOUT} -n ${NAMESPACE} ${MYSQL_RELEASE} keta-chart/mysql --set auth.createDatabase=true --set auth.database=ketadb --set auth.username=keta --set auth.password=${MYSQL_PASSWORD}
	helm upgrade --create-namespace --install --wait --timeout=${TIMEOUT} -n ${NAMESPACE} ${PREFIX}-master --values master.yaml ../../ --set mysql.host=${MYSQL_RELEASE} --set mysql.password=${MYSQL_PASSWORD} --set mysql.user=keta --set mysql.database=ketadb
	helm upgrade --create-namespace --install --wait --timeout=${TIMEOUT} -n ${NAMESPACE} ${PREFIX}-web --values web.yaml ../../ --set mysql.host=${MYSQL_RELEASE} --set mysql.password=${MYSQL_PASSWORD} --set mysql.user=keta --set mysql.database=ketadb
	helm upgrade --create-namespace --install --wait --timeout=${TIMEOUT} -n ${NAMESPACE} ${PREFIX}-data --values data.yaml ../../ --set mysql.host=${MYSQL_RELEASE} --set mysql.password=${MYSQL_PASSWORD} --set mysql.user=keta --set mysql.database=ketadb

uninstall:
	helm del ${PREFIX}-data -n ${NAMESPACE}
	helm del ${PREFIX}-web -n ${NAMESPACE}
	helm del ${PREFIX}-master -n ${NAMESPACE}
	helm del ${MYSQL_RELEASE} -n ${NAMESPACE}

purge:
	kubectl delete ns ${NAMESPACE}

status:
	helm list -n ${NAMESPACE}
	kubectl get pod -n ${NAMESPACE}