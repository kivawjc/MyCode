
<br>
---

#### Restful 服务开发

参考网站: https://blog.csdn.net/haiming157/article/details/80661898

#### 为什么要使用
1. api一定需要开发文档配合，移动端只需要根据开发文档进行开发即可；
2. 传统的开发文档问题：
	1. 格式随意；
	2. 更新不及时；

#### 生成API 文档

swagger/springfox

1. 在parent上添加依赖

```xml
<dependency>
  <groupId>io.springfox</groupId>
  <artifactId>springfox-swagger2</artifactId>
  <version>2.9.2</version>
</dependency>
```

2. 在util中添加配置类

```java
/**
 * swagger的配置对象
 */
@Configuration
@EnableSwagger2
public class SwaggerConfig {

	/**
	 * 把一个Docker交给spring管理
	 * Docket：springfox提供的文档的配置对象；
	 *
	 * @return
	 */
	@Bean
	public Docket api() {
		return new Docket(DocumentationType.SWAGGER_2).select().build();
	}
}
```
3. 访问路径 ： http://localhost:8100/v2/api-docs

4. 添加ui包

```xml
<dependency>
	<groupId>io.springfox</groupId>
	<artifactId>springfox-swagger-ui</artifactId>
	<version>2.9.2</version>
</dependency>
```

5. 集成

```java
@Component
public class SwaggerMvcConfigurerAdapter implements WebMvcConfigurer {

	@Override
	public void addResourceHandlers(ResourceHandlerRegistry registry) {
		registry.addResourceHandler("swagger-ui.html").addResourceLocations(
				"classpath:/META-INF/resources/");

		registry.addResourceHandler("/webjars/**").addResourceLocations(
				"classpath:/META-INF/resources/webjars/");
	}

}
```

6. 访问 http://localhost:8100/swagger-ui.html

#### 相关注解:
```java

@Api：用在类上，说明该类的作用
@Api(value = "用户资源",description = "用户资源控制器")

@ApiOperation：用在方法上，说明方法的作用
@ApiOperation(value = "注册功能",notes = "其实就是新增用户")

```

```java
@ApiImplicitParams：用在方法上包含一组参数说明
@ApiImplicitParam：用在@ApiImplicitParams注解中，指定一个请求参数的各个方面
paramType：参数放在哪个地方
header-->请求参数的获取
query-->请求参数的获取
path-->请求参数的获取（用于restful接口）：
body-->请求实体中


@ApiImplicitParams({
            @ApiImplicitParam(value = "昵称",name = "nickName",dataType = "String",required = true),
            @ApiImplicitParam(value = "邮箱",name = "email",dataType = "String",required = true),
            @ApiImplicitParam(value = "密码",name = "password",dataType = "String",required = true)
})
```


```java
@ApiModel：描述一个Model的信息
（这种一般用在post创建的时候，使用@RequestBody这样的场景，请求参数无法使用@ApiImplicitParam注解进行描述的时候）
@ApiModelProperty：描述一个model的属性


@ApiModel(value="用户",description="平台注册用户模型")
@ApiModelProperty(value="昵称",name="nickName",dataType = "String",required = true)

```

```java
@ApiResponses：用于表示一组响应
@ApiResponse：用在@ApiResponses中，一般用于表达一个错误的响应信息(200相应不写在这里面)
		code：数字，例如400
		message：信息，例如"请求参数没填好"
		response：抛出的异常类

@ApiResponses({
	@ApiResponse(code=200,message="用户注册成功")
})
```

```java
@ApiIgnore
有些接口不想显示，就贴上去，可以贴在类上，也可以贴在方法上。
```
