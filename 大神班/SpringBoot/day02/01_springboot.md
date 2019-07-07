
## SpringBoot的web开发

#### 静态资源

1. 应用是打成jar包,有文件上传需要配置图片所在路径(不能存在jar包内部,放在外部)
2. 修改 spring.resources.staticLocations 来修改静态资源加载地址
3. 默认从classpath下 : /static ,  /public 加载

### 集成freemark
1. 在原来的spring mvc 配置FreeMarker需要把FreeMarkerConfigurer和FreeMarkerViewResolve两个对象配置到Spring容器中

2. 在spring boot中只需要引入freemark依赖

```xml
<!--引入freemarker依赖-->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-freemarker</artifactId>
</dependency>
```

#### 集成原理

* SpringBoot的自动配置中含有FreeMarkerAutoConfiguration配置对象(spring.factories)
  * |-- 该配置对象又导入了FreeMarkerReactiveWebConfiguration配置对象
  * |-- 在里面创建了FreeMarkerConfigurer和FreeMarkerViewResolve
    * |-- 两个对象交给Spring管理,并且设置了默认的属性值,这些属性值来源于FreeMarkerProperties对象

```java
-----------spring.factories-------------
org.springframework.boot.autoconfigure.freemarker.FreeMarkerAutoConfiguration
```


ConditionalOnClass : 条件有这些类的时候，这个类才生效

@Bean
@ConditionalOnMissingBean(
    name = {"freeMarkerViewResolver"}
)
当没有 freeMarkerViewResolver bean 时，配置才生效，防止重复创建对象

```java

@ConfigurationProperties(
    prefix = "spring.freemarker"
)
public class FreeMarkerProperties extends AbstractTemplateViewResolverProperties {
    // 默认模板加载路径
    public static final String DEFAULT_TEMPLATE_LOADER_PATH = "classpath:/templates/";
    //前缀
    public static final String DEFAULT_PREFIX = "";
    //后缀
    public static final String DEFAULT_SUFFIX = ".ftl";
```

enable:

默认请求参数(false)不能覆盖model中的属性
cache : 模板缓存,默认false    nginx: 处理静态资源
charset=utf-8 模板编码
content-type=text/html
实时检查模板修改，修改后不需要重启服务器

暴露 session 对象的属性


<br>
---


### 统一异常处理

1. 使用状态码作为html的名字
2. 使用控制器增强器
  |-- 有异常时会调用该方法

```java
@ControllerAdvice //控制器增强器
public class ExceptionControllerAdvice {

    @ExceptionHandler(Exception.class) //处理什么类型的异
    public String handlException(Exception e, Model model) {
        model.addAttribute("msg", e.getMessage());
        return "errorView"; //逻辑视图名称
    }

}
```

### 拦截器实现
定义一个HelloINterceptor

@Configuration
HelloINterceptor implements  WebMvcConfiguratin
preHeanlder
  if(a==0){
    a+++;
    return false;
  }

// 实现mvc规范的注册拦截方法
  // 注册拦截器对象
  //配置对哪些资源起作用
  //配置排除哪些资源

### 集成Druid
1. 导入依赖
2.
3. 8.x 版本需要添加时区
@Cofigratiojn
DataSourceConfig{

}


### 集成MyBatis
1. 导入mybatis依赖
2. 配置属性
3. 创建domain 和mapper


### 事务管理
1. 添加aop织入的依赖
2. 使用xml方式
3. 使用注解方式
  |-- 2.x 版本不需要加enableManager

### 系统日志

#### 为什么使用日志？
* 日志输出和代码分离,控制日志是否输出
* 定义日志的输出格式和输出级别

springboot 的日志介绍:
* 默认开启了日志
* 分为: 系统日志和应用日志(自己打印的日志)
* 默认选择logback 作为日志框架，也可以选择其他框架


#### Logback 日志的使用
* 默认加载 classpath 下


### springboot 项目改造
1. 配置属性参数
  |-- 端口 连接池  mybatis
