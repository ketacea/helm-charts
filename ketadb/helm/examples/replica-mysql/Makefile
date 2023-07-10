RELEASE := ketadb-replica-mysql
TIMEOUT := 600s
NAMESPACE := keta
MYSQL_PASSWORD := "changeThisPassword"
MYSQL_RELEASE := mysql

init:
	helm repo add keta-chart http://chart-prod.ketaops.cc --force-update
	helm repo update keta-chart

install: init
	helm upgrade --create-namespace --install --wait --timeout=${TIMEOUT} -n ${NAMESPACE} ${MYSQL_RELEASE} keta-chart/mysql --set auth.createDatabase=true --set auth.database=ketadb --set auth.username=keta --set auth.password=${MYSQL_PASSWORD} --set architecture=replication 
	helm upgrade --create-namespace --install --wait --timeout=${TIMEOUT} -n ${NAMESPACE} ${RELEASE} ../../ --set mysql.host=${MYSQL_RELEASE}-primary --set mysql.password=${MYSQL_PASSWORD} --set mysql.user=keta --set mysql.database=ketadb

uninstall:
	helm del ${RELEASE} -n ${NAMESPACE}
	helm del ${MYSQL_RELEASE} -n ${NAMESPACE}

purge:
	kubectl delete ns ${NAMESPACE}