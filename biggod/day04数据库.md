### MySql 基础

---

###### 数据概述
* 数据库(DataBase):数据库是按照数据结构来组织，存储和管理数据的仓库
* 数据库管理系统(DataBase Manager System DBMS):专门用于管理数据库的计算机系统软件,对数据进行增删改查
* 信息管理系统(MIS Management Information System):信息管理系统

###### 数据库技术发展历程
1. 关系型数据库:使用表关系组织数据(Oracle,DB2,MYSQL,SQLServer)
2. 非关系型数据库:面向对象数据库技术
    * NOSQL:(not only) sql:结构化数据库技术

常见的NoSql数据库

表头|表头
---|:--:|---:
键值对存储数据库|[Redis],BeansDB
列式存储数据库|[HBase],Cassandra
文档型数据库|[MongoDB]
图形数据库|Neo4j,Infinite,Graph

##### 常见的关系数据库
```
   数据库系统     所属公司
    Oracle       Oracle
    DB2          IBM
    SQLServer    MS (微软)
    Mysql        AB->SUN->Oracle
```

##### SQL语言
* SQL语言：结构化查询语言(Structured Query Language)对数据库进行操作的语法,关系型数据库标准语言

SQl 包含3个部分
* 数据库定义语言(DDL):在数据库中创建表和删除表
* 数据库操作语言(DML):增删改表中的行
* 数据库查询语言(DQL):数据库检索查询

书写规则
1. sql语句大小写不敏感
2. sql语句可单行和多行书写
3. 关键字大写，其他小写

###### ORM 思想
* 关系型:固定的列和任意的行表示关系
* 二维表:在表中一行称为一条记录,一列成为一个字段
* orm思想(Object Relation Mapping):对象关系映射, 映射表和对象之间的关系

表|面向对象
---|:--:|---:
表结构 |类
表的列 |属性
表的行 |对象


---

##### 链接MySQL数据库


```sql
格式:mysql -u root -p **** -h localhost -P 3306
简写:mysql -u root -p ****
```
##### 操作数据库
```sql
查看数据库
show databases;

使用指定的数据库
use 数据库名

查看指定的数据库中有哪些表
show tables;

创建指定名称的数据库
create dataBase database_name;

删除数据库
drop database database_name;
```

### Mysql 列的常见类型
常用类型

java |MySql
---|:--:|---:
int |INT （4字节）
long |Bigint (8字节)
boolean|bit
Date|DATE/DATETIME
String|varchar

char 和 varchar 的区别
char 是定长字符
varchar 变长字符

http://blog.itpub.net/21374452/viewspace-2136268/

##### 创建表
```sql
语法
create table 表名(
字段 类型 [约束],
name varchar(20),
age int
);

create table student(
id bigint,
name varchar(20),
age int
);

表名的问题:
如果表名使用关键字，需要使用以下俩个方法
1. 使用 `table` 这种反引号格式
2. 使用 t_table 这种前缀
```

```sql
查看表目录
show tables;

查看表结构
desc table_name;

查看创建表的ddl语句
show create table table_name;

删除表
drop table table_name;
```

##### 插入操作
```sql
1> insert into 表名(列名1,列名2) values(值1,值2);
   insert into user(name,age) values('decade',1);

2> insert into 表名 values(值1,值2..); -- 需要带全部的值
   insert into user values(null,'decade',1);
```

##### 删除记录
```sql
1> 不带条件
  delete from 表名;
  delete from user;
2> 带条件
  delete from 表名 where 条件
  delete from user where id=2;
```

##### 更新记录
```sql
1> 不带条件
update 表明 set 字段名=值,字段名=值
update user set name='decade',age=18;

把名字都改为王者
update user set name='王者';
2> 带条件
update 表明 set 字段名=值,字段名=值 where 条件
update user set name='decade',age=18 where id=1;

把所有记录的age+1
update student set age=age+1;

```

##### 查询记录

* distinct :去除重复的数据
* as :取别名,可以省略,添加引号会影响排序
* concat : 连接函数,连接字符串
* binary: 区分大小写

```sql
语法:
select [distinct] *  | 列名,列名 from 表 [where 条件]

1> 简单查询
   1. 查询所有商品信息
      select * from product;

   2. 查询所有商品的id,productName,salePrice
      select id,productName,salePrice  from student;

   3. 查询商品的分类编号(消除结果中重复的数据)
      select distinct dir_id from product;

   4. 查询所有货品的id,名称和批发价(批发价=卖价*折扣)
      select id,product_name,salePrice*cutoff from product;

   5. 查询所有货品的id,名称和各进50个的成本价(成本=costprice)
      select id,product_name,costprice*50 from product;

   6. 查询所有货品的id,名称和各进50个并且每个运费1元的成本
      select id as '编号',product_name '商品名',(costprice+1)*50 from product;

    7. 查询xx的售价是xx
      select concat(productName,'的售价是',salePrice) from product;

2> 比较运算符
    1. 查询货品零售价为119的所有货品信息
      select * from product where salePrice=119;

    2. 查询货品名不为 罗技G9X的所有货品信息  <>  , !=
      select * from product where productName!='罗技G9X';
      识别大小写
      select * from product where binary productName!='罗技G9X';

    3. 查询id,货品名称，批发价大于350的货品--->where上不能加别名
      select id,productName,salePrice*cutoff  from product where salePrice*cutoff>350

      执行顺序: from product -->where pf>350-----> select
      此时不能再使用别名，因为where上还没有pf别名
      error: select id,productName,salePrice*cutoff pf from product where pf>350

3> 逻辑运算符
    1. 选择id,货品名称，零售价再300-400之间的货品
    select id,productName,salePrice from product
    where salePrice>300 and salePrice<400

    2.选择id,货品名称，分类编号是2或4的所有货品
    select id,productName,dir_id from product where dir_id=2 or dir_id=4;

    3. 选择id,货品名称，分类编号不为2的所有商品
    select id,productName,dir_id from product where not dir_id=2;

    4. 选择id,货品名称，分类编号的零售价大于等于250或者成本大于等于200
    select id,productName,salePrice,costprice from product
      where salePrice>=250 or costprice>=200;

4> 范围查询
  1. 选择id,货品名称，零售价在300-400之间的货品
  select id,productName,salePrice from product
  where salePrice between 300 and 400

  2. 选择id,货品名称，零售价不在300-400之间的货品
  select id,productName,salePrice from product
  where salePrice not between 300 and 400

5> 集合查询
  1. 选择id,货品名称，分类编号为2或4的所有货品
  select id,productName,dir_id from product where dir_id in(2,4);

  2. 选择id,货品名称，分类编号不为2或4的所有货品
  select id,productName,dir_id from product where dir_id not in(2,4);

6> 模糊查询
  % 通配符:任意个数的任意字符
  _通配符: 表示一个任意字符

  1. 查询货品名称带有M的所有信息
  select * from product where productName like '%M%'

  2. 查询匹配货品名称 '罗技M9 ?' 的所有信息
  select * from product where productName like '罗技M9%'

  3. 查询匹配货品名称 '罗技M9??' 的所有信息
  select * from product where productName like '罗技M9__'

7> 空值查询
  1. 查询商品分类编号为null的所有商品信息  (不能使用dir_id=null)
  select * from product where dir_id is null;

  2. 查询商品分类编号不为null的所有商品信息
  select * from product where dir_id is not null;

  3. 设置商品id为2的商品的dir_id的值为null
  update product set dir_id=null where id=21;
```


##### 结果排序
使用order by 子句将记录排序
asc : 升序
desc : 降序
```sql
选择id,货品名称，分类编号,零售价先按分类编号排序，编号相同按零售价排序
select id,productName,dir_id,salePrice from product
order by dir_id desc,salePrice

选择id,货品名称，分类编号,零售价大于200,按分类编号排序,编号相同按零售价降序排序
select id,productName,dir_id,salePrice from product
where salePrice>200
order by dir_id,salePrice desc

查询M系列并按照批发价排序
select *,salePrice*cutoff from product
where productName like '%M%'
order by salePrice*cutoff desc

查询分类为2并按照批发价排序(使用别名)
执行顺序: from --> where -->select --> order
别名不能使用引号,否则排序失效

select *,salePrice*cutoff pf from product
where dir_id=2
order by pf desc
```
select 语句执行顺序:
from --> where -->select --> order

```
查询处理的顺序如下:
FROM
ON
JOIN
WHERE
GROUP BY
HAVING
SELECT
DISTINCT
ORDER BY
LIMIT
```


##### 分页查询

> 语法 limit ?,?
  * 参数1: 起始索引，从0开始
  * 参数2:每页记录数

起始索引=(当前页-1)* 每页记录数

分页查询时：从前端输入当前页和每页记录数
```sql
需求:显示6条记录,查询第三页
select * from product limit 12,6;
```
---

##### 表的约束

>* 非空约束:not null，不允许某列为空
* 设置列的默认值:default
* 唯一约束:unique,列的内容必须唯一
* 主键约束:primary key ，非空且唯一
* 主键自增长:auto_increment ,从1开始，步长为1
* 外键约束:foreign key ,A表的外键列的值必须参照于B表中的主键

##### 主键设计
```
1. 单列主键.单列作为主键，建议使用
   复合主键,使用多列当主键,不建议

2. 主键分俩种
自然主键(少见)
        |----表的业务列中，有某业务列符合,
          并且不重复的特征时，该列可以作为主键使用
代理主键(常见)
        |----表的业务列中，没有某业务列符合,
        并且不重复的特征时，创建一个没有意义的列作为主键
```


##### 聚合函数
作用于一组数据,返回一条数据
 ```sql
 count : 结果记录的条数
 max : 最大值
 min : 最小值
 sum : 求和
 avg : 平均数


需求:查询所有商品平均零售价
select avg(salePrice) from product

需求:查询商品总记录数(注意在Java7前必须使用long接收)
count(*) 包括null值
count(字段名) 不包括null值
select count(*) from product

需求:查询分类为2的商品总数
select count(*) from product where dir_id=2;

需求:查询商品的最小零售价，最高零售价，以及所有商品零售价总和
select min(salePrice),max(salePrice),sum(salePrice) from product
 ```

##### 多表查询
注意:给表取别名之后不能用真名
添加外键时需要先设置innodb引擎
删除表时，将从表的外键设为null,再删除主表的数据
开发中为了提高性能，不适用外键约束,外键关系使用java代码约束


总结:
```
mysql 属于关系型数据库，属于oracle公司
orm 思想: 使用面向对象的思维,对象和关系数据表建立联系，操作数据库

连接数据库
mysql -u root -p password

显示数据库
show databases;

显示所有的表
show tables;

获得表结构
desc 表名

创建数据库
create database 数据库名

删除数据库
drop database 数据库名

---sql 语句----
DDL:数据库定义语言,在数据库中创建表和删除表
DML: 数据库管理语言,增删改数据
DQL:查询数据记录

创建表
create table 表名(
  字段 类型 约束，字段 类型 约束
)

删除表
drop table 表名

插入数据
insert into 表名(字段,字段) values(值1，值2)

删除数据
delete from 表名 where 条件

修改数据
update 表名 set 字段=值 where 条件

查询数据
select 字段 from 表名 where 条件
slect * from user;
多字段查询
select id,name,age from user;
运算
select * from user where id=0;
去重
select distinct dir_id from user;
别名
select id as 编号,name 性名 from user;
逻辑元算符
select * from user where age > 0;
判断空值 is null
select * from user where name is null;
范围查询
select * from user where  age between 12 and 15;
集合查询
select * from user where age in(12,15)
```
