### 解决分布式session
1. 使用Redis+cookie 方式
2. 使用Redis+Shiro方式(sessionDao),session不存储在JVM,存储在redis
3. jwt 使用一个密钥记录登陆信息，通过cookie返回给客户，客户每次访问都将密文传递给服务器
4. 修改ngnix的轮询策略 : ip-hash 可以使访问同一个ip
![](assets/01_草稿-54c8f892.png)
