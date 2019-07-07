

### 搭建环境
1. 创建spring-boot 项目
2. 添加 jedis 的驱动包

步骤:
1. 创建jedis 对象连接数据库服务器
2. 测试连接数据库
3. 关闭连接

```java
public void testJedis(){
  // 1. 创建jedis 对象连接数据库服务器(使用连接池)
  JedisPool pool == new JedisPool("localhost", 6379);
  Jedis jedis=pool.getResource();

  // Jedis jedis=new Jedis("localhost");

  //验证密码
  jedis.auth(密码);
  //2.  测试连接数据库
  System.out.println(jedis.ping());

  //TODO
  jedis.set("name","decade");
  jedis.get("name");
  // 3. 关闭连接
  jedis.close();
}
```

### Springboot 整合spring data redis(了解)
1. 添加依赖
2. 配置连接信息

```properties
# 配置连接信息(默认值)
spring.redis.host=localhost
spring.redis.port=6379
# 密码
spring.redis.password=admin
```

```java
public class Test{

  @Autowried
  RedisTemplate redisTemplate;

  public void testRedisTemplate(){
    // spring data redis 操作会有序列化问题
    // 操作string
    redisTemplate.opsForValue().xx();
    // 操作hash
    redisTemplate.opsForHash().xx();
    // 操作list
    redisTemplate.opsForList().xx();
    // 操作set
    redisTemplate.opsForSet().xx();
    // 操作zset
    redisTemplate.opsForZSet().xx();
  }

}
```
