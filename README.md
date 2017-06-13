# docker redis cluster
_使用docker技术部署redis，使用run.sh脚本快速搭建redis集群测试环境_

## 部署redis
*创建redis镜像*
``` bash
./run.sh build 或 docker build -t {image-name} .
```
*运行redis容器*
``` bash
docker run -d -p {port}:6379 --name {container-name} {image-name}
```
## 搭建redis集群测试环境
*创建redis镜像*
``` bash
    ./run.sh build
```
*运行测试redis容器，在脚本中定义了6个测试容器，3主3备，容器ip和端口写死在脚本，请根据自己创建的容器信息修改脚本*
``` bash
    ./run.sh services run
```
*搭建集群*
``` bash
    ./run.sh services cluster
```
*查看集群情况*
``` bash
    redis-cli -h 172.17.0.2 cluster nodes
    
    成功会返回：
    ad40c94d067e777d147eb50912bfbd0882e57718 172.17.0.4:6379 myself,master - 0 0 3 connected 10923-16383
    79955e0ab68ffc48ee508061e95eeb6f9a7dcd51 172.17.0.2:6379 master - 0 1497343516467 1 connected 0-5460
    6a9cd537eb792b8c366860656003396d00c53712 172.17.0.7:6379 slave ad40c94d067e777d147eb50912bfbd0882e57718 0 1497343510197 6 connected
    475b01c06d02849f354cbf5ee576682f87b06ea7 172.17.0.6:6379 slave 0931ddb80f93fe8e418653eeb0c4b5f7f27466cd 0 1497343513430 5 connected
    ae909e1d03dbfca5978f2f88d0a4cf5ae0f2a930 172.17.0.5:6379 slave 79955e0ab68ffc48ee508061e95eeb6f9a7dcd51 0 1497343514444 4 connected
    0931ddb80f93fe8e418653eeb0c4b5f7f27466cd 172.17.0.3:6379 master - 0 1497343515456 2 connected 5461-10922
```
*操作测试容器脚本命令*
``` bash
    ./run.sh services start|restart|stop|rm
```
