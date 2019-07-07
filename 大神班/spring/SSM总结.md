## SSM 知识体系
---

Spring 知识体系
  |-- Spring 概述
      |-- 解决的问题
          |-- 代码耦合度高
          |-- 事务操作繁琐
          |-- 第三方框架运用麻烦
  |-- IoC 容器
      |-- 概述: 控制反转,程序创建对象的操作交由spring IoC容器来创建和管理,
      方便管理项目中对象的生命周期
      |-- 俩种IoC容器
          |-- BeanFactory :Spring 底层接口,只提供IoC功能,在容器启动后，获取对象时才创建对象
          |-- ApplicationContext:实现了BeanFactory，支持AOP,IoC,事务等多种功能
                随着容器启动创建对象
      |-- bean 实例化
      |-- bean 作用域 scope(单例和多例)
      |-- bean 初始化和销毁
          |-- init-method: 在bean对象创建时，做初始化操作
          |-- destory-method:在bean对象销毁时,
  |-- DI 依赖注入
      |-- 概述 : 依赖注入，spring创建对象需要依赖属性或其他对象时，可以通过配置设置属性值
  |-- AOP 思想
      |-- 概述：面向切面编程，横向重复的代码，纵向抽取，可以解决代码的复用性，实现方法增强
      |-- 实现原理:使用动态代理，通过封装具体业务管理操作，对需要实现业务操作的方法进行增强
          |--- 静态代理: 通过创建代理类,实现目标对象的父接口，在实现方法中，
              调用目标对象方法的前后进行业务增强操作
          |--- 动态代理
              |-- jdk 动态代理技术:(有实现接口)通过实现目标对象接口的方式，对目标对象进行代理
              |-- cgLib 动态代理技术:(没有接口实现)通过集成目标对象类的方法，进行代理
  |-- Tx事务支持:
      |-- Spring 提供了基于数据库框架集成的多个事务管理器，提供了事务传播行为,隔离级别，事务是否只读的封装设置
  |-- Spring Test
      |-- Spring 和Juint 整合测试开发，在测试类中可以使用同一个IoC容器对象，方便测试开发
  |-- Spring 注解开发
      |-- IoC 注解
      |-- DI 注解
      |-- Tx 注解

MyBatis 知识体系
  |-- 概述: 半自动ORM框架，支持sql 查询的持久层框架，
      解决了jdbc代码重复，sql语句硬编码，解析结果集硬编码的缺陷
  |-- 核心组件
      |-- SqlSessionFactory : 类似DataSource,运行期间不需要多次创建，使用单例对象维护,用于创建sqlSession对象
      |-- sqlSession : 类似于Connection,每次使用都会创建新的对象，封装了对数据库增删改查的方法
  |-- 配置文件
      |-- 主配置文件: 主要配置了MyBatis的核心配置信息
          |-- 数据库连接四要素
          |-- 懒加载
          |-- 别名
          |-- 关联映射文件
      |-- Mapper 映射文件: 主要配置了对应数据表的sql操作语句
          |-- 增删改查标签
          |-- 动态sql 标签
          |-- resultMap 标签
          |-- ognl 表达式: 使用#{}，获取从根对象中获取值
      |-- Mapper 接口和Mapper 映射文件相对应,根据Mapper去关联映射文件中对应的sql语句
  |-- 缓存机制
      |--一级缓存
          |-- sqlSession对象中存在一个Map存储sql语句以及对应的执行结果集,
            但sqlSession生命周期太短,提升性能有限
      |-- 二级缓存
          |-- 多个sqlSession共享对象,sqlSessionFactory 作用域内
  |-- 多表关系查询: 使用额外sql 方式和多表查询sqL 的俩种方式，实现不同的开发需求

Spring MVC知识体系
  |-- SpringMVC是Spring web的一个组件，用在表现层，提供了请求分发，参数封装，资源映射等多方面功能
  |-- 前端控制器 基于servlet实现的用于分发请求，处理响应流程的控制器
  |-- Spring MVC 的执行流程
        处理器映射器:根据当前请求去查找哪一个Controller 来处理
            |---将拦截器/Controller返回到前端控制器
            |---调用处理器适配器
        处理器适配器：执行controller的方法
            |--- 返回ModelAndView --> 适配器--> 前端控制器
        视图解析:根据ModelAndView 获取View(物理路径)
            |--- 返回路径给前端控制器
        前端控制器使用Model渲染View
  |-- Controller 注解开发
      |-- @RequestMapping : 定义处理器映射的Url
  |-- 请求和响应
      |-- 方法返回值(响应)
        |-- void
        |-- String
        |-- ModelAndView
      |-- 参数接收
        |-- javabean 封装
        |-- 字段封装
  |-- 文件上传下载
        |-- apache 组件上传
        |-- servlet 上传
  |-- 拦截器:类似于Servlet 开发中的过滤器Filter,对Controller 进行预处理和后处理
        |--- 定义拦截器类,实现接口HandlerInterceptor
        |--- 在mvc.xml配置文件中配置拦截器
