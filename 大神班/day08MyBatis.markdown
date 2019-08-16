### MyBatis框架
---
### 框架
1. 一系列jar包，其本质是对JDK功能的拓展
2. 框架是一组程序的集合，解决某一领域的问题

#### ORM 思想
ORM:对象关系映射
* 使用配置文件将java对象和关系数据库表建立关系

ORM 思想:
* 将数据库表中的记录映射成java对象

目前流行的ORM框架:

1. JPA：本身是一种ORM规范,不是ORM框架.由各大ORM框架提供实现.
2. Hibernate：之前最流行的ORM框架.设计灵巧,性能优秀,文档丰富
3. MyBatis：本是apache的一个开源项目iBatis,提供的持久层框架包括SQL Maps和DAO,允许开发人员直接编写SQL.


![](assets/day08MyBatis-d09d08f1.png)

---

#### MyBatis 概述
* MyBatis 是支持普通 SQL 查询,存储过程和高级映射的优秀持久层框架。
* MyBatis 消除 了几乎所有的 JDBC 代码和参数的手工设置以及结果集的检索。
* MyBatis 使用简单的 XML 或注解用于配置和原始映射,将接口和 Java 的 POJOs(Plan Old Java Objects,普通的 Java 对象)映射成数据库中的记录。


#### MyBatis 架构
![](assets/day08MyBatis-c8962db9.png)




#### 准备工作
###### 1. 创建数据表  (R)
```sql
create table user(
id bigint primary key auto_increment,
name varchar(20),
salary decimal(10,2),
hiredate date
)
```
###### 2. 创建user对象 (O)
```java
@Data
@AllArgsConstructor
public class User{
  private Integer id;  //用户id
  private String name;  //用户名
  private BigDecimal salary; //用户薪资
  private Date hiredate;  //入职时间
}
```



###### 3. 导入mybatis核心包

mybatis核心包、依赖包、数据驱动包

![](assets/day08MyBatis-282b4d55.png)

![](assets/day08MyBatis-fd135ea6.png)




##### 4. 全局配置文件
1. 命名:mybatis-config.xml
2. 路径:存放在项目resource目录下
3. 导入约束:在文件中导入约束,在eclipse中xmlcata中导入本地dtd
4. 配置文件的内容

![](assets/day08MyBatis-32a8e837.png)

```
<configuration>
default：指定默认使用哪一个环境(和环境的id一样)
<environments default="dev">

  id:给环境指定名字
  环境中配置:
    事务管理器: JDBC
    数据源:POOLED 配置连接池|UNPOOD 不用连接池

  <environment id="dev">

    事务管理器
    <transactionManager type="JDBC"></transactionManager>

    <dataSource type="POOLED">
      数据库四要素
      <property name="driver" value="com.mysql.jdbc.Driver"></property>
      <property name="url" value="jdbc:mysql:///javaweb"></property>
      <property name="username" value="root"></property>
      <property name="password" value="root"></property>
    </dataSource>

  </environment>
</environments>

关联映射文件可以关联多个
  告诉mybatis去哪获取sql语句
  resource:从bin路径开始查找,属于相对路径
<mappers>
  <mapper resource="sql映射文件的路径"></mapper>
</mappers>

</configuration>
```

##### SQL映射文件 (Mapper)
1. 取名:XXXMapper.xml  -->domain的类名
2. 路径:跟XXXMapper接口在同一个路径
3. 约束:导入mybatis-3-mapper.dtd
4. 文件内容
5. 配置映射



###### -----在eclipse中配置dtd-----
![](assets/day08MyBatis-b9aaadc2.png)

```
namespace命名空间:给当前mapper文件起一个唯一的名字(可以任意)
当使用mapper接口作为方法映射时，需要将namespace改成mapper接口的完整类名
<mapper namespace="">

    id: 标记当前mapper中唯一的sql语句名 (mapper接口的方法名)
    paramterType:传递的参数的类型,可以不写
    在mapper文件中，使用 ognl表达式 #{} 作为值

    useGeneratedKeys:获取自动生成主键
    keyProperty:自动生成主键放在哪个id上

    <insert id="save" paramterType="传递参数" resultType="返回类型" useGeneratedKeys="true" keyProperty="id">
      insert into user(name,salary,hiredate) values(#{name},#{salary},#{hiredate})
    </insert>
</mapper>
```


#### java Api
* 把配置文件的信息交给框架，执行sql语句

操作步骤:
1. 获取SessionFactory
2. 获取SqlSession

```
//1.根据主配置文件获取SqlSession对象
InputStream in=Thread.currentThread()
              .getContextClassLoader()
              .getResourceAsStream("mybatis-config.xml");
InputStream in=Resources.getResourceAsStream("mybatis-config.xml");
SqlSessionFactory sf=new SqlSessionFactoryBuild().build(in);

// openSession(autoCommit)--->可以设置是否手动提交事务
Session session=sf.openSession();

//2.执行sql语句
User user=new User(null,"decade",new BigDecimal("1000.0"),new Date());
//mapper 中 ： namespace + . +id
session.insert("xxxx.UserMapper.save",user);
//3.提交事务---->框架会自动回滚
session.commit();
//4. 释放资源   ---->没有释放资源，会导致连接池对象都分发完，没有归还
session.close();
//获取自动生成主键
System.out.println(user.getId());

```




##### 修改和删除
```

<update id="updateUser">
		update user set name=#{name},age=#{age} where id=#{id}
</update>

// 使用ognl表达式获取简单类型的属性值 #{任意符号}
<delete id="deleteUser">
		delete from user where id=#{id}
</delete>

/**
 * 修改数据
 * @throws Exception
 */
@Test
public void testUpdate() throws Exception {
  //获取sqlSeesion
  InputStream in=Resources.getResourceAsStream("mybatis-config.xml");
  SqlSessionFactory factory=new SqlSessionFactoryBuilder().build(in);
  SqlSession session=factory.openSession();
  //执行语句
  User user=new User(10L, "李白", 20);
  session.update("user.updateUser",user);
  //需要提交事务
  session.commit();
  session.close();
}


/**
 * 测试删除
 * @throws Exception
 */
@Test
public void testDelete() throws Exception {
	//获取sqlSession
	InputStream in=Resources.getResourceAsStream("mybatis-config.xml");
	SqlSessionFactory factory=new SqlSessionFactoryBuilder().build(in);
	SqlSession session = factory.openSession();
	//执行sql语句
	int rows=session.delete("user.deleteUser", 11L);
	//提交事务
	session.commit();
	session.close();
}

```



##### 查询操作
* 查询操作必须设置返回类型
* 查询单个使用selectOne
* 查询多个使用selectList

```
<select id="getUserById" resultType="com.kiva.test.domain.User">
		select * from user where id=#{id}
</select>

<select id="getAll" resultType="com.kiva.test.domain.User">
	select * from user
</select>

/**
	 * 查询指定id的User
	 * @throws Exception
	 */
	@Test
	public void testGetUserById() throws Exception {
		InputStream in=Resources.getResourceAsStream("mybatis-config.xml");
		SqlSessionFactory factory=new SqlSessionFactoryBuilder().build(in);
		SqlSession session = factory.openSession();
		//执行查询语句
		User user=session.selectOne("user.getUserById",2L);
		System.out.println(user);
	}

	/**
	 * 查询列表
	 * @throws Exception
	 */
	@Test
	public void testGetAll() throws Exception {
		InputStream in=Resources.getResourceAsStream("mybatis-config.xml");
		SqlSessionFactory factory=new SqlSessionFactoryBuilder().build(in);
		SqlSession session = factory.openSession();
		List<User> list=session.selectList("user.getAll");
		System.out.println(list);
	}
```


##### 封装MyBatisUtil
```
//数据库连接对象，只创建一次
private static SqlSessionFactory factory;

static{
  //只需要加载一次
  factory=new SqlSessionFactoryBuild()
          .build(Resources.getResourceAsStream("mybatis-config.xml"))
}

public static SqlSession getSession(){
  return factory.openSession();
}
```
---



##### ResultMap
* 列名和属性名匹配，可以使用resultType
* 列名和属性名不匹配，可以使用resultMap

```
type: 要跟哪个类型去映射
id:给resultMap指定一个id
<resultMap type="user完整类名" id="user_map">
  id 标签专门用来处理主键
  <id column="uid" property="id"/>
  <result column="uname" property="name"/>
  <result column="usalary" property="salary"/>
</resultMap>

<select id="save"  resultMap="user_map">
  select * from user
</select>
```



---
#### typeAliases 类型别名
* 在主配置文件中
* 使用typeAliase别名可以在整个MyBatis中使用,不区分大小写

```
<typeAliases>
  <typeAlias type="User完整类名" alias="user"/>
</typeAliases>

给某一个包的所有类设置别名，别名是类的简单类名
<typeAliases>
  <package name="xxxx.domain"/>
</typeAliases>
```

需求:获取用户的总条数

```
java7 使用long ,java8使用int
<select id="getCount" resultType="int">
  select count(*) from user
</select>
```
---





#### 抽取db.properties
* 应该将连接池4要素，放在properties配置文件中,需要修改数据库配置信息时，不需修改主配置文件

```
<configuration>

关联properties文件的路径，classpath开始找
<properties resource="db.properties"></properties>

...
<dataSource type="POOLED">
  数据库四要素
  <property name="driver" value="${driverClassName}"></property>
  <property name="url" value="${url}"></property>
  <property name="username" value="${username}"></property>
  <property name="password" value="${password}"></property>
</dataSource>
...

</configuration>


```

---






#### 日志使用
在代码执行过程中，可以随时查看SQL的变化
* 日志输出和代码分离
* 日志可以定义日志的输出环境:控制台，文件，数据库
* 日志可以定义日志的输出格式和级别

##### 配置日志环境
* 导入日志包
* 配置log4j.properties


log4j.properties:需要修改cn.wolfcode -->打印指定命名空间的日志

```
# Global logging configuration
log4j.rootLogger=ERROR, stdout
# MyBatis logging configuration...
log4j.logger.cn.wolfcode=TRACE
# Console output...
log4j.appender.stdout=org.apache.log4j.ConsoleAppender
log4j.appender.stdout.layout=org.apache.log4j.PatternLayout
log4j.appender.stdout.layout.ConversionPattern=%5p [%t] - %m%n
```

* 日志级别:
ERROR > WARN > INFO > DEBUG > TRACE
* 如果设置级别为INFO，则优先级高于等于INFO级别（如：INFO、WARN、ERROR）的日志信息将可以被输出,小于该级别的如DEBUG和TRACE将不会被输出。
---





#### ognl表达式
OGNL (Object-Graph Navigation Language):对象导航语言,可以存取对象属性，调用对象方法

OGNL 可以直接获取根对象属性(把数据放在某一个容器中),语法 #{}
* 如容器中是一个javabean 对象： #{属性名}
* 如果该容器中是一个map对象: #{key}
* 如果该容器中是简单类型(Integer,String): #{任意}


示例:上下文根对象是employee
```
class Employee{
  String name;
  int age;
  Dept dept;
}

class Dept{
  String name;
}
#{name},#{age},#{dept.name}
#{dept.name} 表示访问了Employee类中的Dept属性的name属性
```
* 存: 在使用session对象去执行SQL命令时，传递的参数放在容器中
* 取: 在mapper文件中取

---

###  Mybatis解决jdbc编程的问题
1. 数据库连接创建、释放频繁造成系统资源浪费从而影响系统性能，如果使用数据库连接池可解决此问题。
   * 解决：在SqlMapConfig.xml中配置数据连接池，使用连接池管理数据库链接。
2. Sql语句写在代码中造成代码不易维护，实际应用sql变化的可能较大，sql变动需要改变java代码。
  * 解决：将Sql语句配置在XXXXmapper.xml文件中与java代码分离。
3. 向sql语句传参数麻烦，因为sql语句的where条件不一定，可能多也可能少，占位符需要和参数一一对应。
  * 解决：Mybatis自动将java对象映射至sql语句，通过statement中的parameterType定义输入参数的类型。
4. 对结果集解析麻烦，sql变化导致解析代码变化，且解析前需要遍历，如果能将数据库记录封装成pojo对象解析比较方便。
  * 解决：Mybatis自动将sql执行结果映射至java对象，通过statement中的resultType定义输出结果的类型。

---

### mybatis与hibernate不同

* Mybatis和hibernate不同，它不完全是一个ORM框架，因为MyBatis需要程序员自己编写Sql语句。
mybatis可以通过XML或注解方式灵活配置要运行的sql语句，并将java对象和sql语句映射生成最终执行的sql，最后将sql执行的结果再映射生成java对象。

* Mybatis学习门槛低，简单易学，程序员直接编写原生态sql，可严格控制sql执行性能，
灵活度高，非常适合对关系数据模型要求不高的软件开发，
例如互联网软件、企业运营类软件等，因为这类软件需求变化频繁，一但需求变化要求成果输出迅速。
但是灵活的前提是[-mybatis无法做到数据库无关性--]，
如果需要实现支持多种数据库的软件则需要自定义多套sql映射文件，工作量大。

* Hibernate对象/关系映射能力强，数据库无关性好，对于关系模型要求高的软件（例如需求固定的定制化软件）如果用hibernate开发可以节省很多代码，提高效率。但是Hibernate的学习门槛高，要精通门槛更高，而且怎么设计O/R映射，在性能和对象模型之间如何权衡，以及怎样用好Hibernate需要具有很强的经验和能力才行。
总之，按照用户的需求在有限的资源环境下只要能做出维护性、扩展性良好的软件架构都是好架构，所以框架只有适合才是最好。

---

```
总结:
1. orm 思想
  |--解决数据库关系表和对象属性不匹配问题
  |---使用配置文件建立关系映射，将关系表属性和对象属性建立联系
2. jdbc 缺陷
  |---代码重复
  |---sql语句硬编码
  |---解析结果集硬编码
3. 框架
  |---一组完成指定功能的jar
4. mybatis
  |---解决了jdbc 缺陷
  |---sql语句在配置文件中书写
5. mybatis 准备工作
  |---导包 : mybatis 核心包/mysql 驱动包 /日志包
  |---导入dtd
  |---创建domain类
  |---书写主配置文件 mybatis-config.xml
      |---引入dtd约束
      |---configuration
        |---environments default：设置默认的环境
            |---environment id:给环境命名
                |--transactionManager  事务处理JDBC
                |--dataSource  数据源,配置连接数据库4大元素

        |---mappers 关联映射文件
            |---mapper
  |---书写映射文件 xxxMapper.xml
      |---mapper namespace : 命名空间，指定当前mapper文件的唯一标识,如果使用接口映射写接口的完整类名
          |---select
          |---delete
          |---update
          |---insert
6. ognl 表达式
  语法: #{}  ,获取容器中对象的属性值
  javabean  : #{属性名}
  map  : #{key}
  简单类型 ： #{任意字符}
7. 主配置文件中配置db.properties
 properties 标签使用 resource 属性引入 db.properties
 使用 ${} 获取配置文件中的配置信息
8. typeAliases 配置别名,在mybatis 项目中配置都能使用,如 select 语句的返回类型
      |---typeAlias ：将哪种类型的类名使用别名标识
            |---type
            |---id
      |---package : 指定包名下的类使用类的简单类名作为别名
9. resultType 和resultMap
    resultType: 在类名和数据表的列名一致时可以
    resultMap：类名和数据表的列名不一致时使用
```
