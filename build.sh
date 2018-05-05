#!/bin/sh
npm run compile
rm -rf blogs-thinkjs.tar.gz
tar -zcf blogs-thinkjs.tar.gz ../blogs-thinkjs
scp blogs-thinkjs.tar.gz root@47.104.157.93:/data/app/service/blogs-thinkjs.tar.gz

rm -rf blogs-thinkjs.tar.gz
echo ' 服务器处理 '
ssh root@47.104.157.93 << eeooff
	cd /data/app/service
	rm -rf blogs-thinkjs
	tar -zxf blogs-thinkjs.tar.gz
	
	echo "kill 掉已经存在的 production.js 进程"
	ps -ef | grep production.js | grep -v 'grep' | awk '{print \$2}' | xargs kill -9

	echo "启动服务，后台运行"

	node blogs-thinkjs/production.js > service.log 2>&1 &
	exit 
eeooff
echo Finished: SUCCESS!
