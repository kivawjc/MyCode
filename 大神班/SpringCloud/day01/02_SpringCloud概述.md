## SpringCloud 概述

相关参考网站 :
官网地址:https://spring.io/projects/spring-cloud
中文地址:https://springcloud.cc/
中文社区:http://springcloud.cn/

### springCloud是什么?
springCloud 是基于SpringBoot提供一套微服务的解决方案,包括服务注册与发现，配置中心,全链路监控，服务网关,负载均衡,熔断器等组件

SpringCloud 利用SpringBoot开发便利性，简化了分布式系统基础设施的开发，SpringCloud为开发人员提供了快速构建分布式系统的工具,包括配置管理

SpringCloud 是分布式架构西啊的一站式解决方案，是各个微服务架构落地技术的集合体，俗称微服务全家桶

### SpringClound和SpringBoot是什么关系
* SpringBoot 专注于快速方便的开发单个个体微服务
* SpringCloud是关注全局的微服务协调整理治理框架，将SpringBoot开发的一个个单体微服务整合并管理起来

* SpringBoot 可以离开SpringCloud 独立使用开发项目，但是SpringCloud 离不开SpringBoot,属于依赖的关系

### SpringCloud 版本说明
因为Spring Cloud不同其他独立项目，它拥有很多子项目的大项目。所以它是的版本是
版本名+版本号 （如Angel.SR6）。
版本名：是伦敦的地铁名
版本号：SR（Service Releases）是固定的 ,大概意思是稳定版本。后面会有一个递增的数字。
所以 Brixton.SR5就是Brixton的第5个Release版本。



#### 版本选择
学习使用的版本为: Greenwich SR1
相关API文档: https://cloud.spring.io/spring-cloud-static/Greenwich.SR1/single/spring-cloud.html
