### linux 系统软件安装的方式

Linux系统是使用软件包管理器来进行软件的安装、卸载和查询等操作的。
软件包管理器又分为后端工具和前端工具。
后端工具有rpm， dpt
前端工具有yum

后端工具存在的问题：
X --->Y
X --->Y --->Z
X --->Y ---X

所以前端工具yum的出现是为了解决后端工具软件依赖关系的问题

如何解决？
具体就是yum工具会根据你要安装的软件解析该软件的依赖树，然后把整个依赖树的软件从网上（yum库）下载下来，再进行安装。
其实yum工具是基于后端软件包管理工具的。

### rpm 安装
```
强制安装
rpm -ivh httpd-2.4.29-5.fc28.x86_64.rpm  --nodeps --force

查询软件是否安装
rpm -q 软件名称

查看所有被安装的软件
rpm -qa |grep httpd

查看安装目录
rpm -ql 软件名称

查看软件的配置文件
rpm -qc 软件名称

卸载
rpm -e 软件名称
```

### yum 常用命令

```
查看yum库中的所有包
yum list

安装软件，会自动添加依赖
yum install 软件名 -y

卸载软件
yum remove 软件名 -y

搜索指定命令对应的软件
yum search 软件名称
```

#### 安装ifconfig
搜索指定命令对应的软件
yum search ifconfig
yum install net-tools.x86_64 -y

#### 安装httpd
yum install httpd -y
