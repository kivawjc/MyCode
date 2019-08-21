

### 参考网站

https://blog.csdn.net/yjt520557/article/details/88880822

## 添加依赖
 * 在pom.xml中添加依赖

```xml
<!-- shiro 集成spring boot -->
<dependency>
    <groupId>org.apache.shiro</groupId>
    <artifactId>shiro-spring-boot-web-starter</artifactId>
    <version>1.4.1</version>
</dependency>

<!--Freemarker的shiro标签库-->
<dependency>
    <groupId>net.mingsoft</groupId>
    <artifactId>shiro-freemarker-tags</artifactId>
    <version>1.0.0</version>
</dependency>
```

### Realm 类


```java
public class CRMRealm extends AuthorizingRealm {

    //设置凭证适配器:从spring 容器中获取，用于对密码进行md5加密
    @Autowired
    @Override
    public void setCredentialsMatcher(CredentialsMatcher matcher) {
        super.setCredentialsMatcher(matcher);
    }

    //获取认证信息
    @Override
    protected AuthenticationInfo doGetAuthenticationInfo(AuthenticationToken token) throws AuthenticationException {

        //获取用户输入的账号密码
        String username=token.getPrincipal().toString();
        //将用户输入账户发送到数据库查询
        Employee employee=mapper.selectByName(username);

        // 查询结果为空,账号错误
        if(employee!=null){
            //查询结果正确，校验密码
            // 登陆添加Md5加密 -  盐(后缀)+ 用户的名字
            return new SimpleAuthenticationInfo(employee,
                    employee.getPassword(),
                    ByteSource.Util.bytes(employee.getName()),
                    this.getName());
        }
        //查询不为空，账号正确，继续校验密码
        return null;
    }


    //获取权限信息
    @Override
    protected AuthorizationInfo doGetAuthorizationInfo(PrincipalCollection principals) {
        // ... 代码不变
    }
}
```

### Shiro 中的配置信息

```java

@Configuration
public class ShiroConfig {

    @Bean
    public Realm realm() {
        return new CRMRealm();
    }


    @Bean
    protected CacheManager cacheManager() {
        return new MemoryConstrainedCacheManager();
    }


    @Bean(name = "shiroFilterFactoryBean")
    public ShiroFilterFactoryBean shiroFilter(SecurityManager securityManager) {
        ShiroFilterFactoryBean shiroFilterFactoryBean = new ShiroFilterFactoryBean();
        // 必须设置SecuritManager
        shiroFilterFactoryBean.setSecurityManager(securityManager);
        Map<String, Filter> filters = shiroFilterFactoryBean.getFilters();

        //配置拦截器,实现无权限返回401,而不是跳转到登录页
        //filters.put("authc", new CRMFormAuthenticationFilter());

        // 如果不设置默认会自动寻找Web工程根目录下的"/login.jsp"页面
        //shiroFilterFactoryBean.setLoginUrl("/login.html");
        // 登录成功后要跳转的链接
        shiroFilterFactoryBean.setSuccessUrl("/department/list");
        // 未授权界面;
        shiroFilterFactoryBean.setUnauthorizedUrl("/403");
        // 拦截器
        Map<String, String> filterChainDefinitionMap = new LinkedHashMap<String, String>();
        // 过滤链定义，从上向下顺序执行，一般将 /**放在最为下边
        // authc:所有url都必须认证通过才可以访问; anon:所有url都都可以匿名访问
        filterChainDefinitionMap.put("/js/**", "anon");
        filterChainDefinitionMap.put("/images/**", "anon");
        filterChainDefinitionMap.put("/css/**", "anon");
        filterChainDefinitionMap.put("/login.html", "anon");


        filterChainDefinitionMap.put("/logout", "logout");
        filterChainDefinitionMap.put("/**", "authc");
        shiroFilterFactoryBean.setFilterChainDefinitionMap(filterChainDefinitionMap);
        return shiroFilterFactoryBean;
    }


    /**
     * 配置md5加密
     * @return
     */
    @Bean("hashedCredentialsMatcher")
    public HashedCredentialsMatcher hashedCredentialsMatcher() {
        HashedCredentialsMatcher credentialsMatcher = new HashedCredentialsMatcher();
        //指定加密方式为MD5
        credentialsMatcher.setHashAlgorithmName("MD5");
        return credentialsMatcher;
    }

    /**
     * 添加这个解决404问题
     * @return
     */
    @Bean
    public static DefaultAdvisorAutoProxyCreator getDefaultAdvisorAutoProxyCreator(){
        DefaultAdvisorAutoProxyCreator defaultAdvisorAutoProxyCreator=new DefaultAdvisorAutoProxyCreator();
        defaultAdvisorAutoProxyCreator.setUsePrefix(true);
        return defaultAdvisorAutoProxyCreator;
    }

}
```


```java
/**
 * 登陆成功或失败都需要返回数据给前端页面
 */
@Component("crmFormAuthenticationFilter")
public class CRMFormAuthenticationFilter extends FormAuthenticationFilter {

    @Override
    protected boolean onLoginSuccess(AuthenticationToken token, Subject subject, ServletRequest request, ServletResponse response) throws Exception {
      // ... 省略代码
    }

    @Override
    protected boolean onLoginFailure(AuthenticationToken token, AuthenticationException e, ServletRequest request, ServletResponse response) {
      // ... 省略代码
    }
}

```
