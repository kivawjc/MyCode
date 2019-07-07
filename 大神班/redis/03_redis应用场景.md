## Redis 应用场景

### 缓存

在项目中对于不常变动的数据，就能缓存起来,避免经常取查询关系型数据库,加快执行效率

// 业务层方法
```java
//业务层方法
public User get(Long id) {
    User user = null;
    //避免多个对象的key一致,采用全限定名:id的形式来作为缓存的key
    String cacheKey = "cn.wolfcode.xxx.domain.User:"+id;
    //从redis中取出数据
    String cacheVal = jedis.get(cacheKey);

    if (cacheVal == null) {
        //redis中没有数据,再从关系型数据库中查询
        user = userMapper.selectByPrimaryKey(id);
        //把查询到的结果存到redis中
        jedis.set(cacheKey, JSON.toJSONString(user));
    } else {
        //redis中有数据,再把该数据解析成一个User对象
        user = JSON.parse(cacheVal, User.class);
    }
    return user;
}
```

### 实时点赞统计

项目在启动时从关系型数据库查询出点赞数量后,把该数据存入redis中,当用户每次点赞时,使用redis提供的incr增加点赞总数,当用户再次查询点赞总数时,直接从redis中查询点赞总数,显示到页面中.再配合定时器,每隔一段时间,把redis中的点赞总数存入到关系型数据库中,完成数据的同步

### 朋友圈点赞

内容的存入格式:
key : user :id : post :id     value:内容   (朋友圈)
key : user :id : post :id :news   value:list
