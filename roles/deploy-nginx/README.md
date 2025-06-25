# Role: deploy-nginx

## 功能

本角色负责在指定的前端节点上，部署 Nginx 作为整个 APISIX 集群的 TCP 负载均衡器。

## 主要任务

1.  分发并加载 Nginx 的 Docker 镜像。
2.  使用模板动态渲染 `docker-compose.yml` 文件。
3.  使用 `nginx.conf.j2` 模板，动态生成一个包含所有 APISIX 后端节点的负载均衡配置文件。
4.  使用 `docker-compose` 启动 Nginx 服务。

## 依赖

-   `deploy-apisix` 角色需要被预先执行，以确保有后端服务可以代理。

## 文件

-   `templates/nginx.conf.j2`: Nginx 的主配置文件模板，用于生成负载均衡策略。

## 变量

-   `deploy_base_dir`: 部署的根目录路径。
-   `nginx_image_repo`, `nginx_image_tag`: Nginx 镜像的仓库和版本。
-   `groups['apisix_nodes']`: 用于在 `nginx.conf.j2` 中生成后端服务器列表。
-   `apisix_http_port`: APISIX 服务暴露的端口。
-   `nginx_http_port`: Nginx 服务对外监听的端口。 