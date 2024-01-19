# mtab-ssh一键部署mtab
---

## 介绍
`mtab.sh` 是一个用于在 Docker 容器中挂载目录并映射端口的 Bash 脚本。该脚本可用于快速设置 Docker 容器并将目录挂载到容器内，同时映射指定的端口。

## 使用方法
SSH 使用
```
bash -c "$(curl -fsSL https://github.com/kokojacket/mtabyi-/blob/main/mtab.sh)" -- --file_location="/目录位置" --container_name="容器名称" --port_number="端口号"
```

**参数说明：**
- `--file_location="/目录位置"`: 指定要挂载到容器内的目录位置。
- `--container_name="容器名称"`: 指定要创建的 Docker 容器的名称。
- `--port_number="端口号"`: 指定要映射的端口号。

**也可以不附加参数**
```
bash -c "$(curl -fsSL https://github.com/kokojacket/mtabyi-/blob/main/mtab.sh)" 
```

## 示例
```bash
bash -c "$(curl -fsSL https://file.kokojy.top:3000/api/public/dl/3_4vKbRT/docker/git/mtab.sh)" -- --file_location="/home/user/data" --container_name="my_container" --port_number="8080"
```
上述示例将会创建一个名为 `my_container` 的 Docker 容器，并将本地 `/home/user/data` 目录挂载到容器内，并映射端口 `8080`。

## 注意事项
- 请确保已经安装 Docker 并且具有足够的权限来执行 Docker 相关操作。
- 在执行命令时，请确保网络连接正常，以便能够通过 `curl` 下载必要的脚本文件。

---
