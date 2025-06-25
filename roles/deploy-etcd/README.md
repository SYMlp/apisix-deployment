# Role: deploy-etcd

## 功能

本角色负责在指定的一组服务器上部署一个高可用的、3节点的 etcd 集群。

## 主要任务

1.  创建 etcd 数据持久化所需的目录。
2.  从 `deploy-apisix` 角色中复制 `docker-compose.yml` 文件。
3.  使用 `docker-compose` 命令，并结合 `inventory` 中定义的环境变量，启动 `etcd` 服务容器。

## 依赖

-   `prepare-common` 角色需要被预先执行。
-   `deploy-apisix` 角色提供了 `docker-compose.yml` 文件。

## 变量

-   `deploy_base_dir`: 部署的根目录路径。
-   `etcd_name`: 在 `inventory.ini` 中为每个 etcd 节点定义，用于 etcd 集群内部的节点命名 (e.g., `etcd-1`)。
-   `inventory_hostname`: Ansible 内置变量，用于获取当前主机的 IP 或主机名。 