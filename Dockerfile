FROM hub.c.163.com/library/ubuntu:trusty

COPY sources.list.trusty /etc/apt/sources.list

RUN apt-get update \
	&& apt-get install -y --no-install-recommends build-essential gcc ruby wget make \
	&& cd /usr/local/src \
	&& wget http://download.redis.io/releases/redis-3.2.9.tar.gz \
	&& tar -zxvf redis-3.2.9.tar.gz \
	&& cd redis-3.2.9 \
	&& make \
	&& cd src \
	&& make install \
	&& mkdir -p /var/log/redis \
	&& rm -rfv /var/lib/apt/lists/*

COPY redis.conf /etc/redis/redis.conf
COPY redis-trib.rb /usr/local/bin/

VOLUME ["/data"]

EXPOSE 6379

CMD ["redis-server", "/etc/redis/redis.conf"]
