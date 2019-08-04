### order-server项目集成Hystrix

步骤:
1. 在order-server中添加hystrix依赖
2. 在启动类中添加@EnableCircuitBreaker注解
3. 在最外层添加熔断降级的处理. 在order-server中的控制器中添加@HystrixCommand(fallbackMethod = "saveFail")注解   （注意fallbackMethod需要和原方法一样的签名）

依赖如下:
```xml
<dependency>
 <groupId>org.springframework.cloud</groupId>
 <artifactId>spring-cloud-starter-netflix-hystrix</artifactId>
</dependency>
```


HystrixCommand : 当方法调用失败，调用fallbackMethod走降级方法，返回兜底数据,具备熔断功能，当方法出错了很多次，不会调用当前方法直接走降级方法
fallbackMethod : 指定出现熔断后需要调用的方法,定义的方法一定要和当前方法签名保持一致

```java
@RestController
@RequestMapping("/order")
public class OrderController {

    @Autowired
    OrderService orderService;

    @RequestMapping("/save")
    @HystrixCommand(fallbackMethod = "saveFail")
    // 当方法调用失败，调用fallbackMethod走降级方法，返回兜底数据,具备熔断功能，
    // 当方法出错了很多次，不会调用当前方法直接走降级方法
    public Object save(Long productId,Long uid){
        System.out.println("----调用save方法--");
        int i=1/0;
        return orderService.save(productId, uid);
    }

    public Object saveFail(Long productId,Long uid){
        System.out.println("------- 走 saveFail 降级方法 ------");
        // 返回兜底数据
        return new Order();
    }

}

```

### Feign集成Hystrix

需求: 在被调用服务报错时，使用熔断, 返回正常数据

1. 在ProductFeignApi的@FeignClient(name = "PRODUCT-SERVER",fallback = ProductFeignHystrix.class)
2. 创建一个ProductFeignHystrix implements ProductFeignApi
3. ProductFeignApi 中指定如果方法出错，调用ProductFeignHystrix 实现的方法
4. 开启 feign 允许hystrix功能
5. 调用者根据返回数据做业务处理

yml 依赖配置:
```yml
# 默认是关闭的，需要手动开启一下
feign:
  hystrix:
    enabled: true
```
相关代码逻辑:
```java
//-------------出现异常时，执行fallback 指定的类的降级方法---
@FeignClient(name = "PRODUCT-SERVER",fallback = ProductFeignHystrix.class)
public interface ProductFeignApi {

    @RequestMapping("/product/get")
    Product getById(@RequestParam("id") long id);

}

@Component
public class ProductFeignHystrix implements ProductFeignApi {
    @Override
    public Product getById(long id) {
        System.out.println("----- 执行被服务类 feign 的降级方法 -------");
        // 业务决定返回的数据
        return null;
    }
}
```


### 熔断降级服务异常报警通知

需求: 在订单出现失败后，调用降级方法时，每隔十分钟通知运维人员

实现: 使用redis 实现

步骤:
1. 添加redis 依赖
2. 注入RedisTemplate
3. 在yml文件配置redis 连接信息

```xml
<dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-data-redis</artifactId>
</dependency>
```

```java
public Object saveFail(Long productId,Long uid){
       System.out.println("------- 走 saveFail 降级方法 ------");
       // 订单出现异常时，隔20分钟发送短信信息通知管理员需要进行异常处理
       new Thread(new Runnable() {
           @Override
           public void run() {
               String key="order-server";
               // 判断redis中是否保存指定的key
               Object o = redisTemplate.opsForValue().get(key);
               if(o==null){
                   System.out.println("正在发送短信");
                   // 否，保存数据  --> 10s 过时 --> 注意有序列化问题需要解决
                   redisTemplate.opsForValue().set(key,"orderFail", 10,TimeUnit.SECONDS);
               }else{
                   System.out.println("已经通知管理员了，不需要重复发送");
               }
           }
       }).start();
       return new Order();
   }
```
