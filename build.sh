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

	nodepid=`ps auxww | grep production.js `

	echo $nodepid
	
	# if [ -z "$nodepid" ]; then
		
	# else
	#     echo 'node service is running'
	#     kill -s USR2 $nodepid 2>/dev/null
	#     echo 'gracefull restart'
	# fi
	node blogs-thinkjs/production.js
	exit 
eeooff
echo Finished: SUCCESS!
