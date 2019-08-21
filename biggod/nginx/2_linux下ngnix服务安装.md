## linux 下安装nginx服务
步骤:
1.进行安装:tar -zxvf nginx-1.6.2.tar.gz

2.下载所需要的依赖库文件:
   yum install pcre -y
   yum install pcre-devel -y
   yum install zlib -y
   yum install zlib-devel -y

3.进行configure配置,查看是否报错
   cd nginx-1.6.2
   ./configure --prefix=/usr/local/nginx

4.编译安装:make && make install

5.在 /usr/local/nginx目录下,可以看到如下4个目录
   conf配置文件,html网页文件,logs日志文件,sbin主要二进制程序

6.启动命令:/usr/local/nginx/sbin/nginx
  关闭命令:/usr/local/nginx/sbin/nginx -s stop
  重启命令:/usr/local/nginx/sbin/nginx -s reload

7.可以使用netstat -ano| grep 80 查看端口.

8.访问浏览器:http://192.168.122.133(看到欢迎页面说明没问题)

注意:如果出现这个错误:./configure: error: C compiler cc is not found
执行这个命令:yum -y install gcc gcc-c++ autoconf automake make
