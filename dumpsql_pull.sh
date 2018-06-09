#!/bin/sh
# 备份出具库数据

scp root@47.104.157.93:/data/app/service/blogs.sql blogs.sql 

# mysql -uroot -proot

# use blogs
# 同步备份的数据
# source /Users/xuxinlong/source/blogs-thinkjs/blogs.sql
# exit

#echo ' 服务器处理 '
#ssh root@47.104.157.93 << eeooff
	#cd /data/app/service
	#mysqldump -u root -p blogs > blogs.sql
	#需要手动输入密码


	#exit 
#eeooff
echo Finished: SUCCESS!