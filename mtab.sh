#!/bin/bash

# 函数：提示用户输入，并使用默认值（如果有）
input_with_default() {
    prompt_message=$1
    default_value=$2
    read -p "$prompt_message (默认为 $default_value)：" user_input
    echo ${user_input:-$default_value}
}

# 解析命令行参数
for arg in "$@"
do
    case $arg in
        --file_location=*)
        file_location="${arg#*=}"
        shift 
        ;;
        --container_name=*)
        container_name="${arg#*=}"
        shift 
        ;;
        --port_number=*)
        port_number="${arg#*=}"
        shift 
        ;;        
    esac
done

# 提示用户输入文件位置，默认为 /opt/docker/mtab 或从命令行参数获取
file_location=${file_location:-$(input_with_default "请输入要创建文件的位置" "/opt/docker/mtab")}

# 如果指定的目录不存在，则询问用户是否创建
if [ ! -d "$file_location" ]; then
    read -p "指定的目录不存在，是否要创建？(y/n): " create_dir_input
    if [ "$create_dir_input" = "y" ]; then      
      if ! mkdir -p "$file_location"; then  
          echo "无法创建目录：$file_location"
          exit 1     
      fi   
    else 
      echo "未能创建目录，退出脚本"
      exit 1      
    fi  
fi

# 提示用户输入容器名称，默认为“mtab”或从命令行参数获取
container_name=${container_name:-$(input_with_default "请自定义 mtab 容器名称" "mtab")}

# 提示用户输入端口号（0-65535），默认为16666或从命令行参数获取。
port_number=${port_number:-$(input_with_default "请自定义 mtab 端口号" "16666")}

echo ""
echo "--- 以下是您提供的信息 ---"
echo "- 文件位置: $file_location"
echo "- 容器名称: $container_name"
echo "- 端口号: $port_number"

cat > "${file_location}/docker-compose.yml" <<EOF
version: '3'
services:
  mtab:
    image: itushan/mtab    
    container_name: ${container_name}
    ports:
      - "${port_number}:80"
    volumes:
      - ./app:/app  
    restart: always   

  mysql:
    image: mysql:8.0    
    container_name: ${container_name}-sql     
    expose:
      - '3306'
    volumes:
      - ./mysql:/var/lib/mysql   
    environment:
      MYSQL_DATABASE: 'mtab'  
      MYSQL_USER: 'mtab'       
      MYSQL_PASSWORD: 'mtab'   
      MYSQL_ROOT_PASSWORD: 'mtab'
volumes:
  mysql_data:

EOF

echo "docker-compose配置文件已创建在${file_location}"

cd "${file_location}" || { echo "切换到目录 ${file_location} 失败"; exit 1; }

echo "使用 docker compose 启动服务..."
if command -v docker-compose &> /dev/null; then
  sudo docker-compose up -d          # 使用docker-compose启动服务，如果存在该命令的话
elif command -v docker &> /dev/null; then  
  sudo docker compose up -d          # 使用docker compose启动服务，如果存在该命令的话  
else  
  echo "无法找到 Docker Compose 命令，请确保已经安装 Docker Compose"
  exit 1    
fi

echo "部署完成，请使用主机IP和端口${port_number}访问服务。例如 http://<主机IP>:${port_number}"
echo ""
echo "数据库信息如下："
echo "- 数据库地址：mysql (容器内地址)"
echo "- 数据库端口号：3306"
echo "- 数据库用户名：mtab"
echo "- 数据库密码：mtab"
echo "- 数据库名称：mtab"


