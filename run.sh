#!/bin/sh
#
# build 创建一个名为redis-node的docker镜像
# servers {run|cluster|add|start|restart|stop|rm} 操作容器
# 	run 创建hosts数组所有容器
#	cluster 根据hosts数组里所有容器创建集群
#	add {port} {name} 添加一个容器
#	start 启动hosts里所有容器
#	restart 重启hosts里所有容器
#	stop 停止hosts里所有容器
#	rm 删除hosts里所有容器
#

image_name="redis-node"

hosts=(
	172.17.0.2:8001:master1
        172.17.0.3:8002:master2
        172.17.0.4:8003:master3
        172.17.0.5:9001:slave1
        172.17.0.6:9002:slave2
        172.17.0.7:9003:slave3
)

case $1 in
"build")
	docker build -t ${image_name} .
	;;
"servers")
	cluster=""
	for host in ${hosts[@]}
        do
		ip=`echo ${host} | cut -d \: -f 1`
                port=`echo ${host} | cut -d \: -f 2`
               	name=`echo ${host} | cut -d \: -f 3`
		if [ "$2"x = "run"x ]
		then
               		docker run -d -p ${port}:6379 --name ${name} ${image_name}
		elif [ "$2"x = "add"x ]
		then
			docker run -d -p $3:6379 --name $4 ${image_name}
		elif [ "$2"x = "cluster"x ] 
		then
			cluster=${cluster}${ip}":6379 "
		else
			docker $2 ${name}
		fi
        done
	if [ "$2"x = "cluster"x ] && [ "$cluster"x != ""x ]
	then
		./redis-trib.rb create --replicas 1 $cluster
	fi
	;;
esac	
