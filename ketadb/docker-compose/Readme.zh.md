# 部署说明
## 前置条件
1. 安装 [docker](https://docs.docker.com/engine/install/)
2. 安装 [docker-compose](https://docs.docker.com/compose/install/standalone/)
## 限制条件
1. Linux amd64 的机器
2. 具有外部网络访问权限（如没有，则需要使用离线镜像）
3. 此方式仅支持单机部署（可单机多节点）

## 安装步骤
1. 将此目录（docker-compose）放到部署目录下，例如：～/docker-compose
2. 修改`.env`中`MYSQL_PASSWORD`参数值，为mysql数据库设置必要的密码（其它参数可以默认）
3. 执行安装
    ```bash
    cd ~/docker-compose
    docker-compose up -d
    # 检查安装结果
    docker-compose ps
    # 查看日志
    docker-compose logs -f ketadb
    ```

## 自定义配置
在`.env`文件中定义了部署可以修改的一些配置

1. 使用自定义存储路径
    ```.env
    ...
    # 持久化配置
    MYSQL_DATA_PATH=./mysql-data
    KETADB_DATA_PATH=./keta-data
    ...
    ```
2. 自定义外部访问端口
    ```.env
    ...
    # web页面端口
    KETADB_WEB_PORT=9200
    # 集群发现端口，当需要组装多个节点时这个端口需要开放给其它机器
    KETADB_UNICAST_PORT=9300
    # keta-agent连接端口
    KETADB_TANSPORT_PORT=9400
    # SPL搜索的rpc端口
    KETADB_SEARCH_RPC_PORT=9500
    ...
    ```
3. 其它
    ```env
        
    # docker 仓库地址
    REPOSITORY=docker.ketaops.cc

    # docker 镜像地址
    KETADB_IMAGE_IMAGE=ketaops/ketadb
    KETA_ML_IMAGE_IMAGE=ketaops/ketadb

    # docker 镜像 tag
    KETADB_IMAGE_TAG=v1.2.1.1
    KETA_ML_IMAGE_TAG=v1.2.1.1

    # JVM OPTIONS
    JVM_OPTIONS="-Xmx2g -Xms2g"

    # MYSQL OPTIONS
    MYSQL_USER=keta
    MYSQL_DATABASE=ketadb
    MYSQL_PASSWORD="123456"
    MYSQL_RANDOM_ROOT_PASSWORD="true"
    ```
## 其它说明
* `mysql`的配置中，默认为mysql的root用户生成了随机的密码，可使用命令`docker-compose logs  mysql |grep "GENERATED ROOT PASSWORD"`查看
* ketadb以及keta-ml的配置均通过环境变量的形式注入，各配置参数参考[参数说明](*todo: ketadb以及ketaml参数说明*)
* 当前部署方式为单机部署，仅限于测试验证使用，不推荐作为生产部署方式。生产部署请参考[k8s部署](../helm/Readme.zh.md)