# Role: deploy-apisix

## 功能

本角色负责在所有 APISIX 节点上部署 APISIX 网关服务，并在监控节点上部署 APISIX Dashboard。

## 主要任务

1.  创建 APISIX 配置文件所需的目录。
2.  将 `docker-compose.yml` 和 `apisix/config.yaml` 复制到目标服务器。
3.  启动 `apisix` 服务。
4.  当目标服务器同时也是监控节点时，额外启动 `apisix-dashboard` 服务。

## 依赖

-   `prepare-common` 角色需要被预先执行。
-   `deploy-etcd` 角色需要被预先执行，以保证 APISIX 有可用的配置中心。

## 文件

-   `files/docker-compose.yml`: 项目核心的 Docker Compose 文件。
-   `files/apisix/config.yaml`: APISIX 的主配置文件。

## 变量

-   `deploy_base_dir`: 部署的根目录路径。
-   `groups['monitoring_node']`: Ansible 内置变量，用于判断当前主机是否存在于 `monitoring_node` 组中。
 