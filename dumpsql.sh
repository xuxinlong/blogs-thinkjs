#!/bin/sh
# 备份出具库数据
mysqldump -u root -p blogs > blogs.sql
scp blogs.sql root@47.104.157.93:/data/app/service/blogs.sql

echo ' 服务器处理 '
ssh root@47.104.157.93 << eeooff
	cd /data/app/service

	# mysql -uroot -p
	# use blogs
	# 同步备份的数据
	# source /data/app/service/blogs.sql

	exit 
eeooff
echo Finished: SUCCESS!