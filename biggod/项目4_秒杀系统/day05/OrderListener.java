package cn.wolfcode.shop.mq;

import com.rabbitmq.client.Channel;
import org.springframework.amqp.core.Binding;
import org.springframework.amqp.core.BindingBuilder;
import org.springframework.amqp.core.TopicExchange;
import org.springframework.amqp.rabbit.annotation.Exchange;
import org.springframework.amqp.rabbit.annotation.Queue;
import org.springframework.amqp.rabbit.annotation.QueueBinding;
import org.springframework.amqp.rabbit.annotation.RabbitListener;
import org.springframework.amqp.support.AmqpHeaders;
import org.springframework.context.annotation.Bean;
import org.springframework.messaging.handler.annotation.Header;
import org.springframework.messaging.handler.annotation.Headers;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.stereotype.Component;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by wolfcode-lanxw
 */
@Component
public class OrderListener {
    // 接收队列消息
    //Payload : 将消息数据反序列化成对象
    @RabbitListener(queuesToDeclare = @Queue(name = MQConstants.ORDER_PEDDING_QUEUE))
    public void handleOrderPenddingQueue(@Payload OrderMessage orderMessage, @Header(AmqpHeaders.DELIVERY_TAG) Long deliveryTag, Channel channel){

    }
    // 监听订单失败队列
    @RabbitListener(bindings =@QueueBinding(
            value = @Queue(name = MQConstants.ORDER_RESULT_FAIL_QUEUE),
            exchange = @Exchange(name = MQConstants.ORDER_RESULT_EXCHANGE,type = "topic"),
            key = MQConstants.ORDER_RESULT_FAIL_KEY
    ))
    public void handleOrderResultFailQueue(@Payload Map<String,Object> param, @Header(AmqpHeaders.DELIVERY_TAG) Long deliveryTag, Channel channel){

    }

    // 监听订单成功队列 -->  定义rabbitlistener会被马上监听,不能实现延时效果
    // 应该只定义一个queue,不被监听
    //传递三个参数
   @Bean
   public org.springframework.amqp.core.Queue delayQueue(){
       Map<String,Object> arguments = new HashMap<>();
       arguments.put("x-dead-letter-exchange",MQConstants.DELAY_EXCHANGE);
       arguments.put("x-dead-letter-routing-key",MQConstants.ORDER_DELAY_KEY);
       arguments.put("x-message-ttl",1000*60*15);
       org.springframework.amqp.core.Queue queue = new org.springframework.amqp.core.Queue(MQConstants.ORDER_RESULT_SUCCESS_DELAY_QUEUE,true,false,false,arguments);
       return queue;
   }
   // 绑定订单成功队列 和交换机的关系
    @Bean
    public Binding binding1a(org.springframework.amqp.core.Queue delayQueue) {
        return BindingBuilder.bind(delayQueue)
                .to(new TopicExchange(MQConstants.ORDER_RESULT_EXCHANGE))
                .with(MQConstants.ORDER_RESULT_SUCCESS_KEY);
    }

    // 监听订单超时
    @RabbitListener(bindings =@QueueBinding(
            value = @Queue(name = MQConstants.ORDER_TIMEOUT_QUEUE),
            exchange = @Exchange(name = MQConstants.DELAY_EXCHANGE,type = "topic"),
            key = MQConstants.ORDER_DELAY_KEY
    ))
    public void handleOrderTimeOutQueue(@Payload Map<String,Object> param, @Header(AmqpHeaders.DELIVERY_TAG) Long deliveryTag, Channel channel){

    }
    @RabbitListener(bindings = @QueueBinding(
            value = @Queue,
            exchange = @Exchange(name = MQConstants.SECKILL_OVER_SIGN_PUBSUB_EX,type = "fanout")
    ))
    public void handleCancelLocalSignQueue(@Payload Long seckillGoodId, @Header(AmqpHeaders.DELIVERY_TAG) Long deliveryTag, Channel channel){}
}
