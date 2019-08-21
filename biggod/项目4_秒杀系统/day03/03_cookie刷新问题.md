
## Cookie 的刷新问题

* 每次访问请求时，都需要携带cookie数据，更新redis 中的token的超时时间，更新浏览器cookie存活时间
* 每个请求都会经过zuul网关，因此自定义网关拦截器，在每次请求后进行token的设置


实现步骤：
1. zuulserver定义一个TokenRefreshFilter,在拦截请求之后进行cookie刷新
2. member 定义一个TokenFeignApi,定义refreshToken() 刷新redis服务器中token的存活时间方法
    * |-- 先判断token是否存在，存在才刷新时间
3. zuulServer需要添加 @EnableFeignClients 注解（服务调用方需要添加）
4. token 在redis 中刷新成功，才需要重新刷新cookie时间


相关代码逻辑如下:

```java
@Component
public class TokenRefreshFilter extends ZuulFilter {

    @Autowired
    TokenFeignApi tokenFeignApi;

    @Override
    public String filterType() {
        // 在每次请求后刷新token
        return POST_TYPE;
    }

    @Override
    public int filterOrder() {
        return 10;
    }

    @Override
    public boolean shouldFilter() {
        // 当浏览器中的cookie包含登陆token时才进行刷新
        RequestContext currentContext = RequestContext.getCurrentContext();
        HttpServletRequest request = currentContext.getRequest();
        String token = CookieUtil.getCookie(request, CookieUtil.USER_TOKEN_COOKIE);
        return !StringUtils.isEmpty(token);
    }

    @Override
    public Object run() throws ZuulException {
        // 远程调用会员服务，刷新token 存活时间
        RequestContext currentContext = RequestContext.getCurrentContext();
        HttpServletRequest request = currentContext.getRequest();
        HttpServletResponse response = currentContext.getResponse();
        String token = CookieUtil.getCookie(request, CookieUtil.USER_TOKEN_COOKIE);
        Result<Boolean> result = tokenFeignApi.refreshToken(token);

        // redis 中的token更新成功后，才更新cookie的时间
        if(result!=null&&result.getData()){
            CookieUtil.addCookie(response,CookieUtil.USER_TOKEN_COOKIE,CookieUtil.USER_COOKIE_AGE,token);
        }
        return null;
    }
}
```

Member 中重新设置redis服务器保存的token的存活时间

```java
public class UserServiceImpl implements IUserService {
  ...
  @Override
  public Boolean refreshToken(String token) {
      //1. 先判断redis中是否存在指定的token,存在才更新
      if(redisTemplate.exist(MemberServerKeyPrefix.USER_TOKEN_PREFIX,token)){
          //2. 更新redis中的token
          return redisTemplate.expire(MemberServerKeyPrefix.USER_TOKEN_PREFIX,token, CookieUtil.USER_COOKIE_AGE)>0;
      }
      return false;
  }
  ...
}
```
