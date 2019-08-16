
订单数据库，e


capital : 资金服务
redpaccket :红包服务
order : 订单服务

capital_account : 用户有多少钱
cap_trade_order : 记录资金的变化


red_packet_account :


shop : 商店对应的店家
product : 商品
order :订单(红包+资金账户)
order_line : 订单明细

transaction_cap : 给TCC 内部去用的

1. 导入sql 数据库表数据
2. 修改dubbo 版本为2.5.7
3. 修改配置文件数据库的密码
4. 配置tomcat
5. 访问 http://localhost:8083/user/2000/shop/1
