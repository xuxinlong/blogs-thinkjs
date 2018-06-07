-- MySQL dump 10.13  Distrib 5.7.21, for Linux (x86_64)
--
-- Host: localhost    Database: blogs
-- ------------------------------------------------------
-- Server version	5.7.21

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `blogs`
--

DROP TABLE IF EXISTS `blogs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `blogs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `text` varchar(10000) COLLATE utf8_unicode_ci NOT NULL,
  `user_id` varchar(20) COLLATE utf8_unicode_ci NOT NULL,
  `time` bigint(12) NOT NULL,
  `type` int(11) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `blogs`
--

LOCK TABLES `blogs` WRITE;
/*!40000 ALTER TABLE `blogs` DISABLE KEYS */;
INSERT INTO `blogs` VALUES (5,'nginx访问资源\"403 Forbidden\"','**nginx访问资源\"403 Forbidden\"**\n    作为一个前端，nginx的403 Forbidden errors，这是个什么鬼？当初的我也是看的一脸懵逼，写好了页面，本地nginx能正常访问，打包后放到服务器上也应该可以访问了，是不是服务器闹鬼了？\n\n    待冷静下来之后，开始查找资料才发现，403是nginx访问文件时权限不足报的错，正常本地调试时起的nginx服务一般是以本机的root权限起的nginx，所以一般的文件的root用户访问的权限都是有的，访问时不会出错，但是部署到服务器之后就不一样了，在小公司的话，服务器在程序员手里可以随便错做，用root权限起个nginx也是没有问题，但是在大公司的话，服务器都是又运维统一管理的，到我们部门运维手里只有普通的用户权限，这个时候我们是无法使用root权限起nginx服务，起的nginx服务也是普通用户权限起的服务，如果不注意文件的权限的话，很有可能就会出现访问服务器资源时报403 Forbidden的错误，所以需要特别注意。\n\n    关于这个403的错误，解决方案有两种，一、使用chmod命令修改项目所有文件夹及文件权限（chmod -R 755 <项目root目录>）；二、在nginx配置文件中配置文件第一行配置 user  root; 但是在服务器上不建议使用这种方法，如果是在本机调试的话可以试试；所以我们的解决方案是在打包脚本中，把项目文件上传到服务器上后，最后执行一条修改项目文件权限的命令。\n\n**文件权限**\n\n \n    关于修改文件权限的命令，这个是linux下对文件的操作命令，这里简单给大家解读一下：\n\n    在项目文件夹下执行命令：  ll\n\n    drwxr-xr-x  11 user  staff   374B  1  3 15:21 source\n\n    可以看到如上信息（只截取了一条记录）：\n\n- 10个字符确定不同用户能对文件操作权限\n\n- 第一个字符代表文件（-）、目录（d），链接（l）\n\n- 其余字符每3个一组（rwx），读（r）、写（w）、执行（x）\n\n- 第一组rwx：文件所有者的权限是读、写和执行\n\n - 第二组r-x：与文件所有者同一组的用户的权限是读、执行但不能写\n\n- 第三组r-x：不与文件所有者同组的其他用户的权限是读和执行不能写\n\n也可用数字表示为：r=4，w=2，x=1  因此rwx=4+2+1=7\n\n- 11 表示连接的文件数\n\n- user 表示用户\n\n- staff表示user用户所在的组\n\n- 374B 表示文件大小（字节）\n\n- 1  3 15:21 表示最后修改日期\n\n- source 表示文件名\n\n','1',1522144226944,1),(6,'http缓存','**http缓存**\n    最近项目刚刚迭代上线，但是更新的内容用户并没有正常更新，看到的依然是以前的旧内容，这是http的缓存导致的。\n\n    http请求在默认情况下是会有缓存的，上述bug出现的原因就是我们没有注意到http的缓存设置。解决的办法就是增加http的缓存策略，通过配置request header的Cache-control，ETag来实现。\n\n**Cache-Control**\n\n    这里对Cache-Control稍作解析一下，首先先看一张图：\n\n\n    这个图很清晰的阐释了http请求被缓存和后续请求的处理，Cache-Control只设置了一个命令max-age=100，第一请求为200，从服务器取的文件，并存储在缓存中，10秒后再请求时，是从缓存取回的数据，而100秒后的请求是先询问了缓存，发现缓存过期，然后再去请求了服务器的资源回来并且更新了缓存内容。\n\n    上面这种缓存策略不是完全可控的，在资源被缓存后没有过期之前，用户是不可能再取到服务器更新的资源。\n\n    在这种情况下使用no-cache命令可以完美解决这个问题，HTTP/1.0使用must-revalidate，HTTP/1.1使用no-cache。nginx配置中设置（也可以通过其它方式设置请求header）：\n\nadd_header Cache-Control \'no-cache,must-revalidate\';\n\n    etag on;\n\n使用no-cache、must-revalidate命令时，请求资源必须先验证它的状态，ETag（验证令牌）就是用来验证缓存资源是否可用的依据。\n\n    Cache-Control缓存设置机制有很多种指令，这里简单介绍一下：\n\n    public：response可以被任何缓存服务器缓存\n\n    private：response可以被除了共享缓存的其它任何缓存服务器缓存\n\n    no-store：缓存不应存储有关客户端请求或服务器响应的任何内容。\n\n    no-cache：所有被缓存的资源请求必须发送到源服务器验证(Most HTTP/1.0 caches will not recognize or obey this directive.)\n\n    must-revalidate：缓存必须在使用之前验证旧资源的状态，不可使用过期资源\n\n    proxy-revalidate：与must-revalidate作用相同，但它仅适用于共享缓存（例如代理），并被私有缓存忽略。\n\n    max-age=<seconds>：设置缓存存储的最大周期，超过这个时间缓存被认为过期(单位秒)。\n\n\n    s-maxage=<seconds>：覆盖max-age 或者 Expires 头，但是仅适用于共享缓存(比如各个代理)，并且私有缓存中它被忽略。\n\n\n    max-stale[=<seconds>]：表明客户端愿意接收一个已经过期的资源。 可选的设置一个时间(单位秒)，表示响应不能超过的过时时间。\n\n    min-fresh=<seconds>：表示客户端希望在指定的时间内获取最新的响应。\n\n','1',1522144362782,1),(7,'shell 提取文件名和目录名','   在写shell脚本中，经常会有需要对路径和文件名做处理。有时候犯不着用sed命令来操作。bash提供的变量操作和一些外部命令都能很好的处理。\n### 一、使用变量操作符 ${}\n#### 1、${var##*/}\n\n该方式是从左开始最大化匹配到字符\"/\"，然后截掉左边内容（包括字符\"/\"）,返回余下右侧部分。\n\n```sh\n$ var=/dir1/dir2/file.txt \n$ echo ${var##*/}  \nfile.txt  \n```	\n在shell脚本中，可以使用变量来保存这个结果，再加以利用，如file=${var##*/}\n我们将\"/\" 换成\".\" \n\n```sh\n$ var=/dir1/dir2/file.txt  \n$ echo ${var##*.}  \ntxt  \n```\n这样就能提取到文件后缀了。\n如果文件的后缀不仅有一个，例如，file.tar.gz，命令${var##*.}仅能提取最后一个后缀，而我想提取tar.gz时该怎么办？那么就要用下面所说的${var#*.}命令了。\n#### 2、${var#*.} \n该方式是从左开始第一次匹配到字符\".\"，然后截掉左边内容（包括字符\".\"）,返回余下右侧部分。\n\n```sh\n$ var=/dir1/dir2/file.tar.gz  \n$ echo ${var#*.}  \ntar.gz  \n```\n这样就可以提取出文件的多个后缀。但是要注意，之前的路径名中不能含有字符\".\"。如果含有的话，读者朋友也应该知道该如何处理啦。\n#### 3、${var%/*}\n该方式是从右开始第一次匹配到字符\"/\"，然后截掉右边内容（包括字符\"/\"）,返回余下左侧部分。\n\n```sh\n$ var=/dir1/dir2/file.txt  \n$ echo ${var%%/*}  \n/dir1/dir2 \n``` \n这样可以提取出我们需要的文件所在的路径\n#### 4、${var%%.*}\n该方式是从右开始最大化匹配到字符\".\"，然后截掉右边内容（包括字符\".\"）,返回余下左侧部分。这里就不举例说明了。\n方法一总结\n\nbash提供的变量操作方法很多，不过这四个对于字符串截取基本够用了。\n\n有一个方便记忆的方法，我们看键盘，\"#\"在\"%\"的左边，当使用#的时候，就说明截掉左边的内容，反之%就是从右边开始截掉。而##和%%就是最大化的截掉。\n\n＊：表示要删除的内容，另外还需要一个字符表示戒掉点。\n\n例如：${var%%x*}表示找出从右侧开始最大化的查找到字符\"x\"，并删除字符x及其右边的字符。\n### 二、basename和dirname\nbasename和dirname命令是专门用来截取文件名和路径名的。\n#### 1、basename\n该命令的作用提取文件名，使用方法为basename NAME [SUFFIX]。\n\n##### 1）从路径中提出出文件名（带后缀），例子如下：\n```sh\n$ var=/dir1/dir2/file.txt  \n$ echo $(basename ${var})  \nfile.txt  \n```\n##### 2）从上面命令的用法中可以看到，后缀（SUFFIX）是一个可选项。所以，若只想提取出文件名file，而不带有后缀，还可以在变量的后面加上后缀名，例子如下：\n```sh\n$ var=/dir1/dir2/file.txt  \n$ echo $(basename ${var} .txt)  \nfile  \n```\n#####2、dirname\n该命令的作用是从路径中提取出路径名，使用方法为 dirname NAME\n使用例子如下：\n\n```sh\n$ var=/dir1/dir2/file.txt  \n$ echo $(dirname ${var})  \n/dir1/dir2  \n```\n这样就提取出了file.txt文件所在的路径。\n注意：该命令不仅能提取出普通文件所在目录，它能提取出任何文件所在的目录，例如目录所在的目录，如下：\n\n```sh\n$ var=/dir1/dir2/  \n$ echo $(dirname ${var})  \n/dir1  \n```\n它提取出了目录dir2所在的目录dir1，所以在使用中要注意到这一点。\n\n\n\n\n\n','1',1523955989660,1),(8,'ssh配置免密登录服务器','### 一、本地配置免密登录远程服务器\n#### 1、生成秘钥对\n```sh\nssh-keygen -t rsa;\n```\n#### 2、将秘钥拷贝到目标服务器\n```sh\nssh-copy-id root@47.104.157.93(远程服务器ip)\n```\n#### 3、ssh免密登录服务器\nssh root@47.104.157.93\n#### 4、本地电脑执行脚本登录目标服务器执行脚本\n\n```sh\necho \' 登录远程服务器执行脚本 \'\nssh root@47.104.157.93 << eeooff\n	str=`ps -ef | grep projectName | grep -v \'grep\' | awk \'{print \\$2}\'`\n	echo \"进程：$str\"\n	for pid in `echo \"$str\" | sed \'s/,/\\n/g\'`\n	do\n		echo \"projectName 进程 pid: $pid\"\n		kill -9 $pid\n	done\n	exit\neeooff\n```','1',1523974468574,1),(9,'shell 远程服务器执行 awx 失效','   通过本地执行shell脚本来kill掉远程服务器上的服务进程\n   \n通过脚本kill掉指定进程名称projectName的进程\n在本机上执行是可以正常kill掉所有的projectName进程：\n\n```sh\n	str=`ps -ef | grep projectName | grep -v \'grep\' | awk \'{print \\$2}\'`\n	echo \"进程：$str\"\n	for pid in `echo \"$str\" | sed \'s/,/\\n/g\'`\n	do\n		echo \"projectName 进程 pid: $pid\"\n		kill -9 $pid\n	done\n```\n本地执行shell脚本来kill掉远程服务器上的projectName进程\n\n```sh\necho \' 服务器处理 \'\nssh root@47.104.157.93 << eeooff\n	str=`ps -ef | grep projectName | grep -v \'grep\' | awk \'{print \\$2}\'`\n	echo \"进程：$str\"\n	for pid in `echo \"$str\" | sed \'s/,/\\n/g\'`\n	do\n		echo \"projectName 进程 pid: $pid\"\n		kill -9 $pid\n	done\neeooff\n```\nbut，上述脚本并不能打到预想的结果，排查了半天的原因，发现命令中 str 无法正常拿到所有 projectName 进程的 pid，然后导致无法拿到 pid 的原因是因为后面的 awk \'print \\$2\' 在无法正确解析，导致没有正确运行得到结果\n\n远程执行shell脚本时，awk \'print \\$2\' 中的 内置变量 $2 转义后还是会出现无法正确解析的问题，为了避免这个问题可以不使用 str 变量，通过 xargs 命令将查询到的 pid 当做参数传递给 kill -9 命令来解决这个问题\n\n```sh\necho \' 服务器处理 \'\nssh root@47.104.157.93 << eeooff\n    ps -ef | grep projectName | grep -v \'grep\' | awk \'{print \\$2}\' | xargs kill -9\neeooff\n```','1',1523977028423,1),(11,'Javascript Event Loop','setTimeout(function(){console.log(1);},0);\nvar id = setInterval(function(){console.log(2);},0);\nsetTimeout(function(){console.log(3);},0);\nconsole.log(4);','1',1527606377447,2),(12,'mysql数据库修改初始登录密码','###启动mysql服务\n\n`\nservice mysqld start \n`\n\n或者\n\n`\nmysql.server start\n`\n\n###修改mysql登录密码\n先登录进mysql\n\n```sql\nuse mysql;\nupdate user set authentication_string=password(\'root\') where user=\'root’;\nflush privileges;\n```','1',1527643572733,2),(13,'android与h5交互','### hybrid App开发也不是什么新鲜事了，其中native和h5之间的交互则是不可避免的。Android中是如何和H5交互的，接下来将为大家简单介绍下。\n\n#### 1. Android 中的 WebView\nandroid中自带android.webkit.WebView（下文中的webView指的是android.webkit.WebView（的实例）。\n通过WebView.loadUrl()方法去加载指定url的网页，例如：\n```java\n//例如：加载网页\nmWebView.loadUrl(\"http://www.baidu.com\")\n```\n#### 2. native本地通过Java调用HTML页面中的JavaScript函数\n如果要在webView中调用页面JavaScript方法需要在webView中添加设置项\n```java\n// setJavaScriptEnabled(boolean flag)\n// Tells the WebView to enable JavaScript execution.\n// 设置允许webView可加载并可以执行js脚本\n\nwebView.getSettings().setJavaScriptEnabled(true);\n```\n若调用的js函数没有返回值，则直接可以调用webView.loadUrl(\"javascript:do()\");其中do是js中的全局函数（window.do）；\n若有返回值时我们可以调用mWebView.evaluateJavascript()方法：\n```java\nmWebView.evaluateJavascript(\"sum(1,2)\", new ValueCallback<String>() {\n    @Override\n    public void onReceiveValue(String value) {\n        Log.e(TAG, \"onReceiveValue value=\" + value);\n    }\n});\n```\njs代码如下：\n```javaScript\n<script type=\"text/javascript\">\n    function sum(a,b){\n        return a+b;\n    }\n    function do(){\n        document.getElementById(\"p\").innerHTML=\"hello world\";\n    }\n</script>\n```\n#### 3. js调用native本地Java方法\n在Android中定义一个类，类中的方式使用@JavascriptInterface注解来声明，再通过addJavascriptInterface将类的实例注册关联上js中的window全局变量，例如：\n```java\npublic class JsInteration {\n    @JavascriptInterface\n    public String back() {\n        return \"hello world\";\n    }\n}\nwebView.addJavascriptInterface(new JsInteration(), \"_WebViewJavascriptBridge\");\n```\n在js中调用：\n```js\n<script type=\"text/javascript\">\nfunction s(){\n    // 调用Java的back()方法\n    var result =window._WebViewJavascriptBridge.back();\n    document.getElementById(\"p\").innerHTML=result;\n}\n</script>\n```\n\n### 总结\nnative与h5交互的关键点在于设置webView允许执行js脚本（webSettings.setJavaScriptEnabled(true)）；native通过webView.addJavascriptInterface注册关联js全局变量window._WebViewJavascriptBridge，通过webView.evaluateJavascript调用页面中全局js函数；js中通过window._WebViewJavascriptBridge调用native中注册的方法\n> native\n```java\n    WebSettings webSettings = mWebView.getSettings();\n    // 设置为可调用js方法\n    webSettings.setJavaScriptEnabled(true);\n    // 注册关联上js中的全局变量window._WebViewJavascriptBridge\n    webView.addJavascriptInterface(new JsInteration(), \"_WebViewJavascriptBridge\");\n    // 调用js中全局函数window.sum\n    mWebView.evaluateJavascript(\"sum(1,2)\", new ValueCallback<String>() {\n        @Override\n        public void onReceiveValue(String value) {\n            Log.e(TAG, \"onReceiveValue value=\" + value);\n        }\n    });\n    \n```\n> js\n```js\n// 调用java中的back方法\nwindow._WebViewJavascriptBridge.back();\n```\n\n关于android与h5的交互已经不少同学做出努力进行了封装\n[WebViewJavascriptBridge](https://github.com/fangj/WebViewJavascriptBridge)','1',1527838969227,1),(14,'微信小程序趟坑','### 提前准备\n首先按照指引[注册一个微信小程序账号](https://mp.weixin.qq.com/wxopen/waregister?action=step1)，注册的时候会生成一个AppID（ps：这个AppID在新建小程序项目的时候回用上），注册完之后，下载安装微信开发者工具，准备工作就完成了。\n### 创建项目\n打开安装好的IDE，在菜单栏中选择 项目-->新建项目，在编辑框中选择项目目录（可以新建一个目录），在AppID栏填入上面注册时生成的AppID，项目名称会根据AppID自动生成（也就是你注册的时候填的项目名称），接下来就可以开发了。\n### 开始趟坑\n开发使用基础库版本为1.9.94\n#### 一、代码结构\n创建一个页面所需要的文件，如下：\n>.json 后缀的 JSON 配置文件\n>.wxml 后缀的 WXML 模板文件\n>.wxss 后缀的 WXSS 样式文件\n>.js 后缀的 JS 脚本逻辑文件\n\n除了json文件以外，其它三个文件与普通html页面文件都能一一对应上，wxml - html,wxss - css, js - js；json文件是小程序页面的配置，包含状态栏、导航条、标题、窗口背景色等。\n#### 二、网路请求服务器域名配置\n服务器域名在 小程序后台-设置-开发设置-服务器域名 中进行配置，配置时需要注意：\n> 域名只支持 https (request、uploadFile、downloadFile) 和 wss (connectSocket) 协议；\n> 域名不能使用 IP 地址或 localhost\n> 域名必须经过 ICP 备案；\n本地调试的时候可以设置使用http协议请求，在项目的设置详情中勾选“不校验合法域名、web-view（业务域名）、TLS 版本以及 HTTPS 证书“\n\n```javaScript\nconst host = \'https://test-h5-biz.taoche.com\';\n// wx.request请求封装\nconst request = function (options) {\n  const opt = {\n    url: host + (options.url[0] === \'/\' ? options.url : \'/\' + options.url),\n    method: options.method,\n    data: {},\n    dataType: \'json\',\n    header: {\n      \'x-access-token\': wx.getStorageSync(\'cookie\') || \'f14ba799-23b2-4c05-8251-7e0fcf9f9782\',\n      \'content-type\': \'application/json\' // 默认值\n    },\n    success: (res) => {\n      if (options.success) {\n        options.success(res.data.data);\n      }\n    },\n    fail: (error) => {\n      if (options.fail) {\n        options.fail(error);\n      }\n    },\n    complete: (res) => {\n      if (options.complete) {\n        options.complete(res);\n      }\n    }\n  };  \n  opt.data = options.data;\n  wx.request(opt);  \n};\n// 请求接口数据\nutil.request({\n  url: \'info/list\',\n  method: \'post\',\n  data: { \n    \"roundStatus\": 2,\n    \"pageNo\": 1,\n    \"pageSize\": 10\n  },\n  success: (res) => {\n    this.setData({ \'auctionLists\': res.record });\n  },\n  fail: (error) => {\n    console.log(\'error\', error);\n  }\n})\n```\n#### 三、wxs模块\n如果使用过vue的filter就很好理解了，功能类似，用法不太一样；\n>1、wxs 不依赖于运行时的基础库版本，可以在所有版本的小程序中运行。\n>2、wxs 与 javascript 是不同的语言，有自己的语法，并不和 javascript 一致。\n>3、wxs 的运行环境和其他 javascript 代码是隔离的，wxs 中不能调用其他 javascript 文件中定义的函数，也不能调用小程序提供的API。\n>4、wxs 函数不能作为组件的事件回调。\n>5、由于运行环境的差异，在 iOS 设备上小程序内的 wxs 会比 javascript 代码快 2 ~ 20 倍。在 android 设备上二者运行效率无差异。\n\n使用时需要配合`<wxs src=\"/lib/base.wxs\" module=\"base\"/>`一起使用，例如：\n```js\n// /lib/base.wxs\n\nvar code = \"test\";\nvar map = {\"test\": \"测试\"};\nvar parseCode = function(d) {\n  return d;\n}\nmodule.exports = {\n  code: code,\n  parseCode: parseCode\n};\n```\n```html\n<!-- page/index/index.wxml -->\n\n<wxs src=\"../../lib/base.wxs\" module=\"base\" ></wxs>\n<view> {{base.code}} </view>\n<view> {{base.parseCode(base.code)}} </view>\n```\n#### 四、template模板\n>可以在模板中定义代码片段，然后在不同的地方调用；\n\ntemplate这个设计非常的nice，当你只是想重复使用html模板，而不需要任何交互的时候，使用component过于繁琐，使用template就再合适不过。\n代码：\n```html\n<!-- /template/common.wxml -->\n<template name=\"no-result\">\n  <view class=\"no-result\">\n    <image src=\"{{img}}\"></image>\n    <text>{{text}}</text>\n  </view> \n</template>\n```\n```html\n<!-- /page/index/index.wxml -->\n<import src=\"../../template/common.wxml\" />\n\n<view>\n    <template is=\"no-result\" data=\"{{...test}}\"></template>\n</view>\n```\n```js\n// /page/index/index.js\nPage({\n  data: {\n    test: {\n      \'text\': \'暂无数据\',\n      \'img\': \'../../static/images/icon_noreqult.png\'\n    }\n  }\n});\n```\n#### 五、页面间传递参数\n页面跳转使用navigator组件或者wx.navigateTo()接口，navigator默认使用的wx.navigateTo跳转，wx.navigateTo打开的页面都是一个单独的webview页面，体验很好，但是传参就不太方便，一下推荐两种方法：\n1、使用url?param=xxx传递参数，这种方法大家都比较好理解，js中获取参数的方法：\n```js\nPage({\n  onLoad: function (options) {\n    console.log(options.param);\n  }\n});\n```\n2、使用getCurrentPages方法获取指定路径的页面page实例，然后设置page实例的data数据即可实现暴力传参。\n```js\nconst getPage = function (route) {\n  let page = null;\n  for (let i = 0, pages = getCurrentPages(), item; item = pages[i++];) {\n    if (item.route === route) {\n      page = item;\n      break;\n    }\n  }\n  return page;\n};\n// 获取页面page实例设置data属性\nconst minePage = util.getPage(\'pages/inde/index\');\nthis.setData({ \'test\': \'测试\'});\n```','1',1528084596664,1),(15,'vue keep-alive 缓存处理','### 场景\n使用vue开发一个单页h5应用，当你进入一个列表页（lsit）加载了十几页的数据，点进去一跳记录查看详情（detail）时，看完后回退到列表页，此时若想停留在你点进详情页时的列表页位置，这种情况下使用缓存技术就会方便许多，推荐使用vue的keep-alive组件\n### keep-alive组件\n\n>**Props：**\n\n* include - 字符串或正则表达式。只有匹配的组件会被缓存。\n* exclude - 字符串或正则表达式。任何匹配的组件都不会被缓存。\n\n>**用法：**\n* \\<keep-alive\\> 包裹动态组件时，会缓存不活动的组件实例，而不是销毁它们。和 \\<transition\\> 相似，\\<keep-alive\\> 是一个抽象组件：它自身不会渲染一个 DOM 元素，也不会出现在父组件链中。\n> **ps:include和exclude是2.1.0新增的，所以vue的版本必须升级到2.1.0 及以上版本才可用**\n\n`include` 和 `exclude` 属性允许组件有条件地缓存。二者都可以用逗号分隔字符串、正则表达式或一个数组。\n\n>思路：\n\n当进入一个指定页面前，监听到路由的变化，根据from和to的路由名匹配cacheComponentList中的规则，然后切换cacheComponentList中的缓存组件，实现根据路由变化规则来动态控制缓存组件。\n>代码：\n```html\n<template>\n  <div id=\"app\">\n      <keep-alive :include=\"includedComponents\" max=\"5\">\n          <router-view></router-view>\n      </keep-alive>\n  </div>\n</template>\n```\n```js\n  // 设置路由缓存的组件\n  const cache = [\'list\', \'edit\'];\n\n  export default {\n    name: \'app\',\n    data() {\n      return {\n        includedComponents: [],\n        cacheComponentList: [\n          /**\n            * Array 页面跳转过程中设置特定页面的缓存\n            * @Param1 {String or Array} required=true; 路由跳转的源路由名称（route.name）；\n            * @Param2 {String or Array} required=true; 路由跳转的目标路由名称（route.name）\n            * @Param3 {String}          required=false; 需要被缓存的路由名称（route.name）；\n            * PS：如果不传@Param3参数将缓存@Param2名称的组件（这种情况需要缓存组件的name为route.name）；\n            */\n          [\'home\', [\'list1\', \'list2\']],\n          [[null, \'home\'], \'list1\'],\n          [[\'null\', \'home\'], [\'list1\', \'list2\']]\n        ],\n      };\n    },\n    watch: {\n      $route(to, from) {\n        // 初始化缓存\n        this.initCache(to, from);\n        if (cache.indexOf(to.name) !== -1) {\n          this.addArrayItem(this.includedComponents, to.name);\n        }\n      },\n    },\n    methods: {\n      removeArrayItem(arr, item) {\n        const index = arr.indexOf(item);\n        (index >= 0) && arr.splice(index, 1);\n      },\n      addArrayItem(arr, item) {\n        const index = arr.indexOf(item);\n        (index < 0) && arr.push(item);\n      },\n      /*\n        * 设置页面缓存\n        * fromName -> toName 设置 cashName 组件缓存\n        * toName -> fromName 删除 cashName 组件缓存\n        * @Param {Route}  from      required=true;路由跳转的源路由对象（route对象）\n        * @Param {Route}  to        required=true;路由跳转的目标路由对象（route对象）\n        * @Param {String} fromName  required=true;路由跳转的源路由名称（route.name）\n        * @Param {String} toName    required=true;路由跳转的目标路由名称（route.name）\n        * @Param {String} cashName  required=true;被缓存的组件名称（component.name）\n        */\n      toggleCache(to, from, fromName, toName, cashName) {\n        if (from.name === fromName && to.name === toName) {\n          this.addArrayItem(this.includedComponents, cashName);\n        } else if (from.name === toName && to.name === fromName) {\n          this.removeArrayItem(this.includedComponents, cashName);\n        }\n      },\n      // 初始化缓存\n      initCache(to, from) {\n        for (let i = 0, item; item = this.cacheComponentList[i++];) {\n          if (item[0] instanceof Array) {\n            for (let n = 0, len = item[0].length; n < len; n++) {\n              this.toggleCache(to, from, item[0][n], item[1], item[2] || item[1]);\n            }\n          } else if (item[1] instanceof Array) {\n            for (let n = 0, _item, len = item[0].length; n < len; n++) {\n              _item = item[1][n];\n              this.toggleCache(to, from, item[0], _item, item[2] || _item);\n            }\n          } else {\n            this.toggleCache(to, from, item[0], item[1], item[2] || item[1]);\n          }\n        }\n      },\n    },\n  };\n\n```','1',1528105094948,1),(16,'react-demo搭建','# blog-react-cdn\n页面引入react实现博客前端页面\n\n### 依赖 \n项目依赖资源react、react-dom、babel-core、babel-standalone，其中babel-core 和 babel-standalone选择安装一个即可\n```sh\n# 指定15.4.2版本安装react\nnpm install --save react@15.4.2\n# 指定15.4.2版本安装react-dom\nnpm install react-dom@15.4.2\n# 指定6.26.0版本安装babel-standalone\nnpm install babel-standalone@6.26.0\n# 指定5.4.0版本安装babel-core\nnpm install babel-core@5.4.0\n```\n\n','1',1528259123111,2);
/*!40000 ALTER TABLE `blogs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(10) COLLATE utf8_unicode_ci NOT NULL,
  `phone` varchar(20) COLLATE utf8_unicode_ci NOT NULL,
  `password` varchar(20) COLLATE utf8_unicode_ci NOT NULL,
  `github_url` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,'jack','18170551225','123456','https://github.com/xuxinlong'),(2,'rose','15201621420','123456',NULL);
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2018-06-07 11:32:32
