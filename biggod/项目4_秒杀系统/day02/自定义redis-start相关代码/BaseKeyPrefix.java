package com.kiva.shop.redis;

/**
 * Created by wujiancheng on 2019/8/6 19:59
 */
public class BaseKeyPrefix implements KeyPrefix{

    private String prefix;
    private int expireTime;


    public BaseKeyPrefix() {
    }

    public BaseKeyPrefix(String prefix, int expireTime) {
        this.prefix = prefix;
        this.expireTime = expireTime;
    }

    @Override
    public String getPrefix() {
        return this.getClass().getSimpleName()+":"+prefix;   // 前缀设计 : 当前类名 + 前缀 + key
    }

    @Override
    public int getExpireTime() {
        return expireTime;
    }
}
