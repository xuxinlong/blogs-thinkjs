	str=`ps -ef | grep production.js | grep -v 'grep' | awk '{print $2}'`
	echo "进程：$str"

	for pid in $str
	do
		echo "production.js 进程 pid: $pid"
		kill -9 $pid
	done