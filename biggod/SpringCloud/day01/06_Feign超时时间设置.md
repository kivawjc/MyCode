### Feign超时时间设置
问题: 如果在调用服务时，服务业务超时？
1. 使用region方式: 会一直等待 (默认60s的超时时间)
2. 使用feign 方式: 等待超时会报错 (默认1s的超时时间)

原因:
源码中默认options中配置的是6000毫秒，但是Feign默认加入了Hystrix,此时默认是1秒超时.

解决方法:
* 可以通过修改配置，修改默认超时时间.
* 在调用服务的一方设置连接时间和读取时间

```yml
feign:
  client:
    config:
      default:
        connectTimeout: 2000
        readTimeout: 2000
```
