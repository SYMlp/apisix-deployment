# Role: prepare-common

## 功能

本角色用于准备所有节点通用的基础环境。

## 主要任务

1.  在所有目标服务器上创建部署所需的根目录（默认为 `/opt/apisix-cluster`）。

## 依赖

-   无

## 变量

-   `deploy_base_dir`: 部署的根目录路径。在 `inventory.ini` 中定义。
-   `ansible_user`: 用于设置目录所有者的用户。在 `inventory.ini` 中定义。
