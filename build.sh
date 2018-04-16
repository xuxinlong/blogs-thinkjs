#!/bin/sh
npm run compile
tar -zcf blogs-thinkjs.tar.gz ../blogs-thinkjs
scp blogs-thinkjs.tar.gz root@47.104.157.93:/data/app/service/blogs-thinkjs.tar.gz

rm -rf blogs-thinkjs.tar.gz
echo ' 服务器处理 '
ssh root@47.104.157.93 << eeooff
	cd /data/app/service
	rm -rf blogs-thinkjs
	tar -zxf blogs-thinkjs.tar.gz
	
	# kill 掉已经存在的 development.js 进程
	str=`ps -ef | grep development.js | grep -v 'grep' | awk '{print$2}'`
	for pid in `echo "$str" | sed 's/,/\n/g'`
	do
		echo "development.js 进程 pid: $pid"
		kill -9 $pid
	done

	node blogs-thinkjs/production.js
	kill $$
	exit 
eeooff
echo Finished: SUCCESS!
