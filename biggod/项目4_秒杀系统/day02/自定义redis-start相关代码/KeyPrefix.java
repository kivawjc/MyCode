package com.kiva.shop.redis;


/**
 * Created by wujiancheng on 2019/8/6 19:11
 * 保存redis key 前缀和超时时间
 */
public interface KeyPrefix {

    String getPrefix();
    int getExpireTime();

}
