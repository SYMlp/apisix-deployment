# Role: deploy-monitoring

## 功能

本角色负责在指定的监控节点上部署 Prometheus 和 Grafana 服务。

## 主要任务

1.  创建 Prometheus 和 Grafana 数据持久化所需的目录。
2.  从 `deploy-apisix` 角色中复制 `docker-compose.yml` 文件。
3.  复制 `prometheus/prometheus.yml` 配置文件。
4.  启动 `prometheus` 和 `grafana` 服务。

## 依赖

-   `prepare-common` 角色需要被预先执行。
-   `deploy-apisix` 角色提供了 `docker-compose.yml` 文件。

## 文件

-   `files/prometheus/prometheus.yml`: Prometheus 的主配置文件。

## 变量

-   `deploy_base_dir`: 部署的根目录路径。 