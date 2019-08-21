package com.kiva.shop.redis;

import lombok.Getter;
import lombok.Setter;
import org.springframework.boot.context.properties.ConfigurationProperties;

/**
 * Created by wujiancheng on 2019/8/6 18:59
 */

@Setter@Getter
@ConfigurationProperties(prefix = RedisProperties.REDIS_PREFIX)
public class RedisProperties {

    public static final String REDIS_PREFIX = "redis";

    private String host = "localhost";
    private int port = 6379;
    private int timeout= 10;
    private String password;
    private int poolMaxTotal = 500;
    private int poolMaxIdle = 500;
    private int poolMaxWait = 500;

}
