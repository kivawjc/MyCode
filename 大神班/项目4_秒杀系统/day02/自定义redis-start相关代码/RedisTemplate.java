package com.kiva.shop.redis;

import com.alibaba.fastjson.JSON;
import org.springframework.beans.factory.annotation.Autowired;
import redis.clients.jedis.Jedis;
import redis.clients.jedis.JedisPool;


/**
 * Created by wujiancheng on 2019/8/6 18:51
 *  redis 操作对象
 */
public class RedisTemplate {


    @Autowired
    JedisPool jedisPool; // jedisPool连接池


    /**
     *  保存数据
     * @param prefix
     * @param key
     * @param data
     * @param <T>
     */
    public <T> void set(KeyPrefix prefix,String key,T data){
        try(  Jedis jedis = jedisPool.getResource();){
            String realKey=prefix.getPrefix()+":"+key;
            String value=beanToJson(data);

            // 判断是否需要设置超时
            if(prefix.getExpireTime()<-1){
                // 不需要设置超时时间
                jedis.set(realKey,value);
            }else{// 设置超时时间
                jedis.setex(realKey,prefix.getExpireTime(),value);
            }
        }catch (Exception e){
            e.printStackTrace();
        }
    }

    /**
     * 获取数据
     * @param prefix
     * @param key
     * @param clazz
     * @param <T>
     * @return
     */
    public <T> T get(KeyPrefix prefix,String key,Class<T> clazz){
        try(  Jedis jedis = jedisPool.getResource();){
            String realKey=prefix.getPrefix()+":"+key;
            String value = jedis.get(realKey);
            return stringToBean(value,clazz);
        }catch (Exception e){
            e.printStackTrace();
        }
        return null;
    }

    /**
     * 判断key是否存在
     * @param prefix
     * @param key
     * @return
     */
    public boolean exist(KeyPrefix prefix,String key){
        try(  Jedis jedis = jedisPool.getResource();){
            String realKey=prefix.getPrefix()+":"+key;
            return jedis.exists(realKey);
        }catch (Exception e){
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 设置超时时间
     * @param prefix
     * @param key
     * @param expireTime
     * @return
     */
    public Long  expire(KeyPrefix prefix,String key,int expireTime){
        try(  Jedis jedis = jedisPool.getResource();){
            String realKey=prefix+":"+key;
            return jedis.expire(realKey,expireTime);
        }catch (Exception e){
            e.printStackTrace();
            return -3L;
        }
    }


    public Long incr(KeyPrefix prefix,String key){
        try(  Jedis jedis = jedisPool.getResource();){
            String realKey=prefix.getPrefix()+":"+key;
            return jedis.incr(realKey);
        }catch (Exception e){
            e.printStackTrace();
            return Long.MIN_VALUE; // 每次递增，成功时不可能为最小值，因此设置失败时返回最小值
        }
    }

    public Long desr(KeyPrefix prefix,String key){
        try(  Jedis jedis = jedisPool.getResource();){
            String realKey=prefix.getPrefix()+":"+key;
            return jedis.decr(realKey);
        }catch (Exception e){
            e.printStackTrace();
            return Long.MAX_VALUE; // 每次递减，成功时不可能为最大值，因此设置失败时返回最大值
        }
    }

    private <T> T stringToBean(String strVal, Class<T> clazz) {
        if(clazz==null){
            return null;
        }
        if(clazz==int.class||clazz==Integer.class){
            return (T) Integer.valueOf(strVal);
        }else if(clazz==long.class||clazz==Long.class){
            return (T) Long.valueOf(strVal);
        }else if(clazz==short.class||clazz==Short.class){
            return (T) Short.valueOf(strVal);
        }else if(clazz==double.class||clazz==Double.class){
            return (T) Double.valueOf(strVal);
        }else if(clazz==boolean.class||clazz==Boolean.class){
            return (T) Boolean.valueOf(strVal);
        }else if(clazz == String.class){
            return (T) strVal;
        }else{
            return JSON.parseObject(strVal,clazz);//把对象的JSON字符串转出指定类型的对象
        }
    }

    
    private <T> String beanToJson(T data) {
        // 如果是基本数据类型不需要进行转换
        Class<?> clazz = data.getClass();
        if(int.class==clazz||Integer.class==clazz){
            return data+"";
        }else if(short.class==clazz||Short.class==clazz){
            return data+"";
        }else if(long.class==clazz||Long.class==clazz){
            return data+"";
        }else if(double.class==clazz||Double.class==clazz){
            return data+"";
        }else if(boolean.class==clazz||Boolean.class==clazz){
            return data+"";
        }else if(String.class==clazz){
            return data.toString();
        }
        return JSON.toJSONString(data);
    }


}
