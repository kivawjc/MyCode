package com.kiva.shop.redis;

import org.springframework.boot.autoconfigure.condition.ConditionalOnBean;
import org.springframework.boot.autoconfigure.condition.ConditionalOnClass;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import redis.clients.jedis.Jedis;
import redis.clients.jedis.JedisPool;
import redis.clients.jedis.JedisPoolConfig;


/**
 * Created by wujiancheng on 2019/8/6 18:55
 */
@Configuration
@ConditionalOnClass(value = {JedisPool.class, Jedis.class})// 必须拥有对应的类才加载配置文件
@EnableConfigurationProperties(RedisProperties.class) // 加载配置文件
@ConditionalOnProperty(prefix = "redis",name = "host")//配置文件中要有redis.host属性
public class RedisAutoConfiguration {

    // 创建 RedisTemplate + JedisPool
    @Bean
    public JedisPool getJedisPool(RedisProperties redisProperties){
        JedisPoolConfig config=new JedisPoolConfig();
        config.setMaxIdle(redisProperties.getPoolMaxIdle());
        config.setMaxTotal(redisProperties.getPoolMaxTotal());
        config.setMaxWaitMillis(redisProperties.getPoolMaxWait());
        return new JedisPool(config,redisProperties.getHost(),redisProperties.getPort(),redisProperties.getTimeout(),redisProperties.getPassword());
    }


    @Bean
    public RedisTemplate getRedisTemplate(){
        return new RedisTemplate();
    }


}
