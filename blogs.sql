-- MySQL dump 10.13  Distrib 5.7.21, for osx10.12 (x86_64)
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
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `blogs`
--

LOCK TABLES `blogs` WRITE;
/*!40000 ALTER TABLE `blogs` DISABLE KEYS */;
INSERT INTO `blogs` VALUES (1,'无标题','ceshi','1',1519224459139),(2,'博客测试数据','博客测试数据，博客测试数据，博客测 试数据，博客测试数据，博客测试数据','1',1518746820380),(3,'无标题','fdasfdsalfkadjsfdksla;dfsa\n','1',1519305587393),(4,'无标题','ceshi','1',1519310873429),(5,'nginx访问资源\"403 Forbidden\"','**nginx访问资源\"403 Forbidden\"**\n    作为一个前端，nginx的403 Forbidden errors，这是个什么鬼？当初的我也是看的一脸懵逼，写好了页面，本地nginx能正常访问，打包后放到服务器上也应该可以访问了，是不是服务器闹鬼了？\n\n    待冷静下来之后，开始查找资料才发现，403是nginx访问文件时权限不足报的错，正常本地调试时起的nginx服务一般是以本机的root权限起的nginx，所以一般的文件的root用户访问的权限都是有的，访问时不会出错，但是部署到服务器之后就不一样了，在小公司的话，服务器在程序员手里可以随便错做，用root权限起个nginx也是没有问题，但是在大公司的话，服务器都是又运维统一管理的，到我们部门运维手里只有普通的用户权限，这个时候我们是无法使用root权限起nginx服务，起的nginx服务也是普通用户权限起的服务，如果不注意文件的权限的话，很有可能就会出现访问服务器资源时报403 Forbidden的错误，所以需要特别注意。\n\n    关于这个403的错误，解决方案有两种，一、使用chmod命令修改项目所有文件夹及文件权限（chmod -R 755 <项目root目录>）；二、在nginx配置文件中配置文件第一行配置 user  root; 但是在服务器上不建议使用这种方法，如果是在本机调试的话可以试试；所以我们的解决方案是在打包脚本中，把项目文件上传到服务器上后，最后执行一条修改项目文件权限的命令。\n\n**文件权限**\n\n \n    关于修改文件权限的命令，这个是linux下对文件的操作命令，这里简单给大家解读一下：\n\n    在项目文件夹下执行命令：  ll\n\n    drwxr-xr-x  11 user  staff   374B  1  3 15:21 source\n\n    可以看到如上信息（只截取了一条记录）：\n\n- 10个字符确定不同用户能对文件操作权限\n\n- 第一个字符代表文件（-）、目录（d），链接（l）\n\n- 其余字符每3个一组（rwx），读（r）、写（w）、执行（x）\n\n- 第一组rwx：文件所有者的权限是读、写和执行\n\n - 第二组r-x：与文件所有者同一组的用户的权限是读、执行但不能写\n\n- 第三组r-x：不与文件所有者同组的其他用户的权限是读和执行不能写\n\n也可用数字表示为：r=4，w=2，x=1  因此rwx=4+2+1=7\n\n- 11 表示连接的文件数\n\n- user 表示用户\n\n- staff表示user用户所在的组\n\n- 374B 表示文件大小（字节）\n\n- 1  3 15:21 表示最后修改日期\n\n- source 表示文件名\n\n','1',1522144226944),(6,'http缓存','**http缓存**\n    最近项目刚刚迭代上线，但是更新的内容用户并没有正常更新，看到的依然是以前的旧内容，这是http的缓存导致的。\n\n    http请求在默认情况下是会有缓存的，上述bug出现的原因就是我们没有注意到http的缓存设置。解决的办法就是增加http的缓存策略，通过配置request header的Cache-control，ETag来实现。\n\n**Cache-Control**\n\n    这里对Cache-Control稍作解析一下，首先先看一张图：\n\n\n    这个图很清晰的阐释了http请求被缓存和后续请求的处理，Cache-Control只设置了一个命令max-age=100，第一请求为200，从服务器取的文件，并存储在缓存中，10秒后再请求时，是从缓存取回的数据，而100秒后的请求是先询问了缓存，发现缓存过期，然后再去请求了服务器的资源回来并且更新了缓存内容。\n\n    上面这种缓存策略不是完全可控的，在资源被缓存后没有过期之前，用户是不可能再取到服务器更新的资源。\n\n    在这种情况下使用no-cache命令可以完美解决这个问题，HTTP/1.0使用must-revalidate，HTTP/1.1使用no-cache。nginx配置中设置（也可以通过其它方式设置请求header）：\n\nadd_header Cache-Control \'no-cache,must-revalidate\';\n\n    etag on;\n\n使用no-cache、must-revalidate命令时，请求资源必须先验证它的状态，ETag（验证令牌）就是用来验证缓存资源是否可用的依据。\n\n    Cache-Control缓存设置机制有很多种指令，这里简单介绍一下：\n\n    public：response可以被任何缓存服务器缓存\n\n    private：response可以被除了共享缓存的其它任何缓存服务器缓存\n\n    no-store：缓存不应存储有关客户端请求或服务器响应的任何内容。\n\n    no-cache：所有被缓存的资源请求必须发送到源服务器验证(Most HTTP/1.0 caches will not recognize or obey this directive.)\n\n    must-revalidate：缓存必须在使用之前验证旧资源的状态，不可使用过期资源\n\n    proxy-revalidate：与must-revalidate作用相同，但它仅适用于共享缓存（例如代理），并被私有缓存忽略。\n\n    max-age=<seconds>：设置缓存存储的最大周期，超过这个时间缓存被认为过期(单位秒)。\n\n\n    s-maxage=<seconds>：覆盖max-age 或者 Expires 头，但是仅适用于共享缓存(比如各个代理)，并且私有缓存中它被忽略。\n\n\n    max-stale[=<seconds>]：表明客户端愿意接收一个已经过期的资源。 可选的设置一个时间(单位秒)，表示响应不能超过的过时时间。\n\n    min-fresh=<seconds>：表示客户端希望在指定的时间内获取最新的响应。\n\n','1',1522144362782);
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
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,'jack','18170551225','123456');
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

-- Dump completed on 2018-03-31 15:03:51
