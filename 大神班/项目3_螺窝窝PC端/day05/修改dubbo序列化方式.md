
dubbo 有2中序列化方式

Hession : 需要所有类必须实现 Serializable, 同时需要存在一个 空参数构造器 [默认使用]
kryo : 也是一种序列方式, 这个相对Hession 速度更快, 不需要实现 Serializable,

必须配置到服务生产者
#序列化方式
dubbo.protocol.serialization=kryo

添加依赖
<dependency>
   <groupId>com.esotericsoftware</groupId>
   <artifactId>kryo</artifactId>
   <version>4.0.2</version>
</dependency>

<dependency>
   <groupId>de.javakaffee</groupId>
   <artifactId>kryo-serializers</artifactId>
   <version>0.45</version>
</dependency>

website 删除dev-tool
