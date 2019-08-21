### 授权管理

---

### Shiro 授权概述
* 系统的授权模块是指用户在访问某些资源需要验证权限才能访问

* 权限模块分为3个子模块
    * 1. 用户模块 2. 角色模块 3. 权限模块

* 只需将用户在将用户拥有的角色和权限告知shiro，shiro会自动对权限进行管理，
提供权限检验使用的方式

#### Shiro 的授权方式
第一种方式:编程式 通过写if/else授权代码块完成
```java

Subject subject = SecurityUtils.getSubject();
if(subject.hasRole("admin")) {
  //有权限
} else {
  //无权限
}
```
第二种方式:使用注解
```java
@RequiresRoles("admin")
@RequiresPermissions("user:create")
public void hello() {
 //有权限
}
```
第三种方式:shiro标签,在freemark种通过标签判断是否根据权限显示或隐藏布局
```xml
<@shiro.hasRole name="admin">
 <!-- 有权限 -->
</@shiro.hasRole>
```

<br>
---

### 1. 基于ini 的授权

* 在ini文件配置用户拥有的权限和角色，权限表达式主要在权限校验时使用

#### 权限表达式的配置规则:
* 用户权限规则:用户名=密码,角色1,角色2..

* 角色权限规则: 角色=权限表达式1,权限表达式2..

* 权限表达式: 资源标识符：操作：资源实例标识符,如 user:delete:1 ,资源实例标识符可以表示要操作的数据记录如id=1

实现步骤:
1. 定义ini 文件配置用户-角色-权限关系
2. 测试当前用户是否拥有指定的权限和角色的数据

ini 文件内容如下:
```
-----------ini文件--------------
# 配置 用户角色权限信息 用户=密码,角色1,角色2
[users]
decade=123,role1,role2
kiva=666,role1

# 角色=权限表达式
[roles]
role1=user:list,user:save
role2=user:delete
```
示例测试代码：

```java
  /**
   * 测试权限管理
   */
  @Test
  public void test02() {

      //加载shiro 配置文件，读取用户配置信息(账号+密码)
      IniSecurityManagerFactory factory=new IniSecurityManagerFactory("classpath:shiro.ini");
      //获取安全管理器
      SecurityManager manager = factory.getInstance();
      //加载安全管理器到当前运行环境中
      SecurityUtils.setSecurityManager(manager);

      //获取用户主体对象
      Subject subject = SecurityUtils.getSubject();
      //创建用户登陆凭证
      UsernamePasswordToken token=new UsernamePasswordToken("decade","123");
      System.out.println("认证前"+subject.isAuthenticated());
      try {
          subject.login(token);
      }catch (UnknownAccountException e){
          System.out.println("账户不存在");
      }catch (IncorrectCredentialsException e){
          e.printStackTrace();
          System.out.println("密码不一致");
      }

      System.out.println("认证后"+subject.isAuthenticated());

      System.out.println("----------权限管理-----------");

      System.out.println(subject.isPermitted("user:list"));//是否拥有指定的权限
      //是否拥有指定的多个权限 -以数组返回结果
      boolean[] permitted = subject.isPermitted("user:list", "user:add");
      System.out.println("isPermitted:"+Arrays.toString(permitted));

      System.out.println("hasRole:"+subject.hasRole("role1"));//是否拥有指定角色的权限

      //是否拥有指定多个角色的权限-以数组返回结果
      boolean[] hasRoles = subject.hasRoles(Arrays.asList("role1", "role2"));
      System.out.println("hasRoles:"+Arrays.toString(hasRoles));

      //是否拥有指定所有角色的权限--> 都有时才会返回true
      System.out.println("hasAllRoles:"+subject.hasAllRoles(Arrays.asList("role1","role2")));

  }
```
运行结果:

```java
认证前false
认证后true
----------权限管理-----------
true
isPermitted:[true, false]
hasRole:true
hasRoles:[true, true]
hasAllRoles:true
```

<br>
---

### 基于Realm的授权

步骤:
1. 自定义realm extends AuthorizingRealm(认证+权限+缓存)
2. 实现 doGetAuthorizationInfo 提供权限信息（根据用户身份凭证查询角色+权限）
3. 在ini中配置realm

自定义realm doGetAuthorizationInfo 核心代码
```java
public class AuthorizationRealm extends AuthorizingRealm {

    //获取认证信息
    protected AuthenticationInfo doGetAuthenticationInfo(AuthenticationToken token) throws AuthenticationException {...}

    //获取权限信息
    @Override
    protected AuthorizationInfo doGetAuthorizationInfo(PrincipalCollection principals) {
        //获取当前用户的角色和权限信息封装到AuthorizationInfo
        SimpleAuthorizationInfo info=new SimpleAuthorizationInfo();

        //获取用户的角色
        List<String> roles=new ArrayList<>();
        roles.add("role1");
        roles.add("role2");

        //获取用户的权限信息
        List<String> permission=new ArrayList<>();
        permission.add("user:list");
        permission.add("user:delete");

        //封装到 AuthorizationInfo 权限信息
        info.addRoles(roles);
        info.addStringPermissions(permission);
        return info;
    }
}
```

ini文件中配置realm
```java
#自定义的Realm信息
crmRealm= com.kiva.crm.realm.AuthorizationRealm
#将crmRealm设置到当前的环境中
securityManager.realms=$crmRealm
```

<br>
---

### 权限注解+web shiro 环境授权

##### 权限数据生成:
* 配置注解: 使用shiro 提供的权限注解配置在controller的需要权限管理的方法上
* 扫描注解: 通过扫描对应类的方法，获取方法上的权限表达式，并保存到数据库中.

##### shairo获取权限信息:
> 在自定义realm doGetAuthorizationInfo方法中，从数据库中查询用户相关权限表达式和角
色编号，作为shiro权限认证的信息.

<br>
##### 步骤:
1. 在Controller 方法上添加权限 RequiresPermission
    * |-- value 指定当前方法需要的权限
    * |-- logical : 设置当前用户是否必须拥有所有的权限才能访问当前方法,会将value提供的数据当作表达式使用,可以设置同时成立或单独成立。
        * |--- AND :同时拥有，默认值
        * |--- OR :拥有其中任何一个即可
2. 添加一个权限注解扫描器，当扫描到controller 方法中有权限注解时，使用spring动态代理生成controller的代理对象
3. service 中使用reload方法,扫描controller注解,获取注解上权限表达式，保存到数据库中
4. web 环境的shiro授权:在realm 中重写获取权限信息的方法
    * |-- 如果是超级管理员，授予其admin的角色和所有权限
    * |-- 将用户拥有的角色和权限添加到授权信息对象中，供Shiro权限校验时使用
5. 全局异常处理(没有权限时,shiro 会报出异常信息)
    * |-- 使用springMVC全局异常处理

详细代码实现细节如下:

##### 注解配置
```java
@RequiresPermission(value={"部门列表","department:list",logical=Logical.OR})
```
##### 注解扫描器配置
在开启扫描器之后，shiro 会为了贴注解的controller对象生成代理对象
代理对象的作用:是为了贴注解的方法增加检查权限的功能

* 只有方法中贴了shiro注解的controller才会被代理
* 生成动态代理对象使用的是spring 中的动态代理,需要开启aop,如果使用注解方式需要开启aop注解扫描

```xml
<bean class="org.apache.shiro.spring.security.interceptor.AuthorizationAttributeSourceAdvisor">
   <property name="securityManager" ref="securityManager"/>
</bean>
```

#### 生成权限信息

在controller 方法上贴shiro 的权限注解,在开启扫描器之后，shiro 会为了贴注解的对象生成代理对象,<font color='red'>所以在容器中获取到的controller是对用的代理对象，而不是真实的Controller获取权限注解时,需要获取controller对象的父类中的方法</font>


```java
   @Autowired
   ApplicationContext ctx;
   /**
    * 重新加载权限
    */
   @Override
   public void reload() {

       //--------去重处理-----查询数据库中所有的表达式
       List<String> expressions=mapper.selectAllExpression();


      //获取类中有Controller注解的对象
       //key ：对象名  value : 对象
       Map<String, Object> beansWithAnnotation = ctx.getBeansWithAnnotation(Controller.class);
       Collection<Object> values = beansWithAnnotation.values();

       for (Object value:values) {
           //3. 获取controller对象的有添加权限注解的方法
           // shiro 扫描生成的代理对象，而不是原始controller对象，因此，需要获得代理对象的父类，再获取方法
           Method[] methods = value.getClass().getSuperclass().getDeclaredMethods();

           for(Method m:methods){
               //4. 判断方法上是否有权限注解---------不然会报null
               if(m.isAnnotationPresent(RequiresPermissions.class)){
                   RequiresPermissions anno=m.getAnnotation(RequiresPermissions.class);

                   // 5. 获取方法上的注解的参数
                   String[] params=anno.value();
                   String name=params[0];
                   String expression=params[1];

                   //6. 保存权限记录----- 会导致重复插入数据
                           //如果数据库中不包含这条数据，则保存
                   if(!expressions.contains(expression)){
                       mapper.insert(new Permission(null,name,expression));
                   }
               }
           }
       }
   }
```

#### 获取权限信息
步骤:
1. 获取当前登陆的用户和权限，封装到AuthorizationInfo对象中并返回
2. 如果当前用户是超级管理员，添加admin角色和所有权限 *:*
3. 如果不是超管，查询前用户的角色和权限，完成授权

注意:
1. \*:\* 表示所有权限，即不做任何限制
2. 获取用户身份信息的对象是在获取认证信息时设置的
    * new SimpleAuthenticationInfo(emp,emp.getPassword(),this.getName());
3. 获取权限信息访问的时机
  * 每次访问需要权限的资源时都会被执行
  * 加了shairo标签的页面显示时也会被执行
4. 如果使用shiro权限管理时，访问没有权限的资源时，会报没有权限的异常，因此需要使用springmvc 的全局异常捕获

```java

//获取权限信息
   // 每次访问需要权限的资源时都会被执行
   // 加了shairo标签的页面显示时也会被执行
   @Override
   protected AuthorizationInfo doGetAuthorizationInfo(PrincipalCollection principals) {
     // 获取当前登陆的用户和权限，封装到AuthorizationInfo对象中并返回
       SimpleAuthorizationInfo info=new SimpleAuthorizationInfo();

       //获取用户身份信息： 俩种方式
       Employee employee= (Employee) principals.getPrimaryPrincipal();
//       SecurityUtils.getSubject().getPrincipal();

       //如果当前用户是超级管理员，添加admin角色和所有权限 *:*
       if(employee.isAdmin()){
           info.addRole("admin");
           info.addStringPermission("*:*");
           return info;
       }

       //否则，需要获取用户的身份信息，根据身份信息，查询数据库中对应的角色和权限

       //查询当前用户的角色信息(sn)
       List<String> roleSn =roleMapper.selectRoleSNByEmpId(employee.getId());
       //查询当前用户的权限信息(expression)
       List<String> permissions =employeeMapper.selectExpressionByEmployeeId(employee.getId());

       //添加用户的角色和权限
       info.addRoles(roleSn);
       info.addStringPermissions(permissions);
       return info;
   }
```

#### 统一异常处理
在springmvc 中做统一异常处理
```xml
<!--统一处理异常-->
	<bean class="org.springframework.web.servlet.handler.SimpleMappingExceptionResolver">
		<!-- 定义默认的异常处理页面，当该异常类型的注册时使用 -->
		<property name="defaultErrorView" value="common/error"/>
		<!-- 定义异常处理页面用来获取异常信息的变量名，默认名为exception -->
		<property name="exceptionAttribute" value="ex"/>
		<!-- 定义需要特殊处理的异常，用类名或完全路径名作为key，异常页面路径作为值 -->
		<property name="exceptionMappings">
			<value>
				org.apache.shiro.authz.UnauthorizedException=common/nopermission
			</value>
		</property>
	</bean>
```
##### 异步请求没有权限异常处理
需要使用@ExceptionHandler注解的方式来设置对应异常处理,ajax 不会自动跳转到没有权限的界面,返回json数据

@ControllerAdvice:Controller增强器
> 通常和@ExceptionHandler、@InitBinder、@ModelAttribute注解配合使用，其中最常用的是
@ExceptionHandler，对Controller中的异常作特定处理。

@ExceptionHandler:异常处理器
>贴在方法上，当Controller中配置指定异常时，会执行贴了该注解的方法。

示例代码:
```java
/**
 *  用来处理异步请求异常处理,Spring 容器创建
 * */
@ControllerAdvice
public class UnauthorizedExceptionUtil {


    /**
     * controller 出现指定异常的方法时，会调用这个对象指定异常类型的方法
     * @param response
     * @param method
     * @param ex  异常类型，参数不能少
     */
    @ExceptionHandler(UnauthorizedException.class)
    public void handler(HttpServletResponse response, HandlerMethod method,UnauthorizedException ex) throws Exception {
        // 判断这个方法是否是返回json数据的注解配置
        if(method.getMethod().isAnnotationPresent(ResponseBody.class)){
            JsonResult result=new JsonResult();
            result.sendErrorMsg("对不起，您没有权限进行此操作");
            response.setContentType("application/json;charset=utf-8");
            response.getWriter().print(JSON.toJSON(result));
        }else{
            throw ex; //抛出异常会被配置文件中统一异常处理
        }
    }


}
```

<br>
---

### Shiro 标签
需求:shiro提供的根据用户拥有的权限来控制显示具体的页面

步骤:
1. 添加依赖
    * |-- shiro-freemarker-tags
2. freemark默认不支持shiro标签，需要继承FreeMarkerConfigurer,重写afterPropertiesSet()方法，添加shiro标签配置
3. 修改freework 配置模板，修改成自己定义的类
4. 书写标签

代码示例:
##### 注入shiro 标签到freeMark中
```java
public class CRMFreeMarkerConfigurer extends FreeMarkerConfigurer {

    @Override
    public void afterPropertiesSet() throws IOException, TemplateException {
       //如果不加这行代码，父类原本的标签不能使用
        super.afterPropertiesSet();
        Configuration configuration = this.getConfiguration();
        //  shiro"表示标签前缀   ShiroTags： 设置哪些标签
        configuration.setSharedVariable("shiro",new ShiroTags());
    }
}
```
在mvc.xml中修改配置freemark配置模板使用 CRMFreeMarkerConfigurer
```xml
<!--配置freeMarker的模板路径 -->
<bean class="com.kiva.crm.shiro.tag.CRMFreeMarkerConfigurer">
	<!-- 配置freemarker的文件编码 -->
	<property name="defaultEncoding" value="UTF-8" />
	<!-- 配置freemarker寻找模板的路径 -->
	<property name="templateLoaderPath" value="/WEB-INF/views/" />
</bean>
```
标签的使用
```java
1. authenticated标签：已认证通过的用户。
<@shiro.authenticated></@shiro.authenticated>

2. notAuthenticated标签：未认证通过的用户。与authenticated标签相对。
<@shiro.notAuthenticated></@shiro.notAuthenticated>

3. principal标签：
输出当前用户信息，通常为登录帐号信息 <@shiro.principal property="name" />
    principal : 身份对象,在realm 中登陆时设置的用户对象
    name: 身份对象中的属性名

4. hasRole标签：验证当前用户是否属于该角色
<@shiro.hasRole name=”admin”>Hello admin!</@shiro.hasRole>

5. hasAnyRoles标签：验证当前用户是否属于这些角色中的任何一个，角色之间逗号分隔 ，
<@shiro.hasAnyRoles name="admin,user,operator">Hello admin!</@shiro.hasAnyRoles>

6. hasPermission标签：验证当前用户是否拥有该权限 ，<@shiro.hasPermission
name="/order:*">订单/@shiro.hasPermission>
```

<br>
---

### MD5 加密

测试

```java
public void testMD5(){
  // 加密内容  后缀 加密次数
  Md5Hash hash=new Md5Hash("1","decade",3);
  System.out.print(hash.toString());
}
```

##### CRM 项目使用MD5 加密
1. 在保存用户数据的时候，对用户的密码进行加密保存
      * |-- 在service saveOrUpdate 方法中完成

2. 登陆认证时需要将用户输入明文密码加密成MD5密文和数据库中的进行校验
    * |-- realm类中配置盐 (后缀),加密使用的盐是用户的名字
    * |-- 配置shrio凭证匹配器,指定加密算法(也可以指定匹配次数) (shiro.xml)
    * |-- 注入到Real中凭证匹配器的setter方法上(从容器中设置凭证匹配器，然后设置Realm 的credentialsMatcher属性)
        * |-- 原因: 默认的凭证匹配器 SimpleCredentialsMatcher 没有加密功能,因此需要配置一个具有加密工具的凭证匹配器
        * |-- 手动将凭证匹配器注入到realm中(使用Autowired)

细节:
* @Autowired :可以用在字段上或set方法上
  * 如果贴在字段上是通过反射操作Field对象
  * 如果setter方法上，此时通过内省机制操作属性，为属性设值


1. 保存用户数据的时候，对用户的密码进行加密保存

```java
-----------MD5Util工具类--------
public class MD5Util {
    public static String getMd5Str(Object source, Object salt){
        return new Md5Hash(source,salt).toString();
    }
}

------------service------------
@Override
public void saveOrUpdate(Employee employee,Long[] roleIds) {
    //添加时需要 保存关联角色的关系数据
    //修改时需要先删除相关角色关系数据，再保存
    if(employee.getId()==null){
        //保存密码之前需要进行md5加密
        employee.setPassword(
                MD5Util.getMd5Str(employee.getPassword(),employee.getName()));
        mapper.insert(employee);
    }
}
```

2. realm 中配置盐,加密时使用用户名作为后缀，生成MD5密码

```java
//获取认证信息
  @Override
  protected AuthenticationInfo doGetAuthenticationInfo(AuthenticationToken token){
    ....
          // 登陆添加Md5加密 -  盐(后缀)+ 用户的名字
          return new SimpleAuthenticationInfo(employee,
                  employee.getPassword(),
                  ByteSource.Util.bytes(employee.getName()),
                   this.getName());
  }

```
3. 在shiro.xml 配置使用哪一种加密方式的凭证匹配器

```xml
<!--配置md5算法 凭证适配器: 用于对密码进行加密 -->
 <bean class="org.apache.shiro.authc.credential.HashedCredentialsMatcher">
     <!--设置加密的算法-->
     <property name="hashAlgorithmName" value="MD5"/>
 </bean>
```
4. 将凭证匹配器对象注入到Real中凭证匹配器的setter方法上

```java
//设置凭证适配器:从spring 容器中获取，用于对密码进行md5加密
 @Autowired
 @Override
 public void setCredentialsMatcher(CredentialsMatcher credentialsMatcher) {
     super.setCredentialsMatcher(credentialsMatcher);
 }
```


数据库md5加密的sql
> * select md5("wolfcode1")
* update employee set password=md5(concat(name,password))

<br>
---

### 集成Ehcache 缓存
需求:
* 页面中如果有相关shiro标签或访问需要权限的资源时，都会执行一次授权信息的代码,授权代码中的sql查询会被多次执行
* 每次检查用户权限都会去执行获取权限,查询数据

解决方法:
> 如果每次授权都要去查询数据库就太频繁了,性能不好. 而且用户登陆后,授权信息一般很少变动,所有我们可以在第一次授权后就把这些授权信息存到缓存中,下一次就直接从缓存中获取,避免频繁访问数据库。
* Shiro中没有实现自己的缓存机制，允许Shiro
用户根据自己的需求灵活地选择具体的CacheManager。这里我们选择使用EhCache。

步骤:
1. 添加依赖
2. 导入ehcache配置文件(shiro.xml文件中)
3. shiro.xml文件中配置ehcache 缓存管理器
4. 安全管理器设置ehcache 缓存管理器
5. 清除缓存操作

添加依赖
```xml
<!--shiro底层使用的ehcache缓存-->
<dependency>
    <groupId>org.apache.shiro</groupId>
    <artifactId>shiro-ehcache</artifactId>
    <version>${shiro.version}</version>
</dependency>

<!--ehcache缓存-->
 <dependency>
     <groupId>net.sf.ehcache</groupId>
     <artifactId>ehcache-core</artifactId>
     <version>2.6.8</version>
 </dependency>
```
导入ehcache配置文件
```xml
<?xml version="1.0" encoding="UTF-8"?>
<ehcache xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:noNamespaceSchemaLocation="http://ehcache.org/ehcache.xsd"
        updateCheck="false">

<defaultCache
        //保存的元素最大个数
        maxElementsInMemory="1000"
        //允许永久保存在内存中
        eternal="false"
        timeToIdleSeconds="600"
        timeToLiveSeconds="1200"
        //最近最少使用
        memoryStoreEvictionPolicy="LRU" />
</ehcache>
```

shiro.xml配置缓存管理器，将缓存管理器配置到安全管理器中
```xml
<!-- ehcache 缓存管理器-->
<bean id="ehCacheManager" class="org.apache.shiro.cache.ehcache.EhCacheManager">
    <property name="cacheManagerConfigFile" value="classpath:shiro-ehcache.xml"/>
</bean>
<!--配置安全管理器 ： 添加realms 数据源 -->
<bean id="securityManager" class="org.apache.shiro.web.mgt.DefaultWebSecurityManager">
   <property name="realm" ref="crmRealm"/>
   <property name="cacheManager" ref="ehCacheManager"/>
</bean>
```


#### 清空缓存
需求:
1. 用户注销后会重新清空缓存
2. 浏览器关闭后会重新清空缓存
2. 用户修改权限后，不退出系统，修改权限无法立即生效

解决方法:
1. 在realm 中定义clearCache，调用清除缓存的方法
2. 在角色service->saveOrUpdate中进行修改时,调用realm 中的clearCache

clearCache 方法定义如下:
```java
/**
* 在修改权限之后需要立即生效，需要清除缓存,调用 doGetAuthorizationInfo 重新查询,才能即时生效
* 在角色修改权限后执行
*/
public void clearCached() {
   super.clearCache(SecurityUtils.getSubject().getPrincipals());
}
```

<br>
---

总结:
```
shiro 的授权
  1. 生成权限数据
      贴注解:
      |-- 使用shiro 提供的注解在controller中指定的需要权限访问的方法上配置权限表达式
      扫描注解：
      |-- 提供重新加载权限的方法，重新加载权限时扫描controller类下的权限方法，获取权限表达式保存到数据库中
      |-- 权限注解的作用:生成代理对象，对方法进行权限增强处理
  2. 提供权限信息供shiro 校验
      |-- 在每次获取权限信息时查询数据库中用户的权限和角色信息返回给shiro(角色可加可不加，需要时才加上)
      |-- 如果时超管则添加 admin =*：*
      |-- 不是超管，按照用户的emyployeeId查询对应的角色信息和权限信息
  3. 访问用户不具有的权限会出现异常， 需要同时配置springmvc全局异常处理
shiro 标签
    |-- 作用:在freemark种通过标签判断是否根据权限显示或隐藏布局
    |-- 使用: 使用前需要在freemark配置模板中配置支持shiro标签

MD5加密
1. 在保存时加密
2. 在spring 容器中配置使用的凭证匹配器
3. 设置加密时用到的盐
    |-- reaml中获取认证信息方法中实现
4. 将当前容器中配置的凭证匹配器设置到当前realm中
    |-- autowried

集成Ehcache
    |-- 作用: 避免每次获取权限信息都去查询数据库
    |-- 使用将ehcache配置文件配置到shiro.xml中安全管理器
```
