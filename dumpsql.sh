#!/bin/sh
mysqldump -u root -p blogs > blogs.sql
scp blogs.sql root@47.104.157.93:/data/app/service/blogs.sql

echo ' 服务器处理 '
ssh root@47.104.157.93 << eeooff
	cd /data/app/service
	exit 
eeooff
echo Finished: SUCCESS!