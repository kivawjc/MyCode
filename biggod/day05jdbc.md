## JDBC


###### JDBC 概述
* 持久化:将内存中的数据保存到硬盘上

jdbc 访问数据库的形式:
1. 直接使用jdbc的api去访问数据库服务器
2. 间接使用jdbc的api,如Hibernate/MyBatis等

##### 获取数据库连接
步骤:
1. 导入mysql连接驱动包
2. 注册驱动 (Driver驱动类)
3. 获取数据库连接对象 (DriverManager.getConnection())
4. 生成预编译语句对象
5. 执行sql命令
6. 释放资源

常用API:
```
Connection 对象:
     Statement  createStatement() : 创建预编译语句的对象，封装了对sql 的操作
  Statement 对象:
      execute():
      executeQuery(): 执行DQL
      executeUpdate(): 执行DDL和DML
      close(): 关闭资源
```

### 注册驱动
```java
//方式一:注册驱动 -->会直接引用具体的数据库驱动类
DriverManager.registerDriver(new Driver());

//方式二:加载Driver字节码，执行静态代码块
Class.forName("com.mysql.jdbc.Driver");

//静态代码块中,当Driver加载进虚拟机时，加载注册驱动
static{
  DriverManager.registerDriver(new Driver());
}
```

###### 获取连接

```java
DriverManager.getConnection(url,user,password);
url:连接到数据库的地址, 包括协议, ip ,端口，数据库名
jdbc:mysql://localhost:3306/javaweb
  协议          ip      端口  数据库名

```

```java
public void getConnection(){
  //1.加载注册驱动
  Class.forName("com.mysql.jdbc.Driver");
  //2.获取数据库连接对象
  Connection conn=DriverManager.getConnection("jdbc:mysql://localhost:3306/user","root","root");
  //如果数据库服务器在本机端口时3306，省略不写
  Connection conn=DriverManager.getConnection("jdbc:mysql:///user","root","root");
}
```

##### 创建表(DDL)
需求: 使用jdbc 创建student表,包含id,name,age 3个列

create table student(
id bigint primary key auto_increment,
name varchar(20),
age int
)
```java
public void testCreateTable(){
  String sql="create table student(
  id bigint primary key auto_increment,
  name varchar(20),
  age int
  )";
  //1. 加载驱动
  Class.forName("com.mysql.driver.Driver");
  // 2. 获取连接
  Connection conn=DriverManager.getConnection("jdbc:mysql:///user","root","root");
  //3. 创建语句对象
  Statement statement=conn.createStatement();
  //4. 执行sql命令
  statement.executeUpdate(sql);
  // 5. 释放资源,先开启的后关闭
  statement.close();
  conn.close();
}
```
###### 执行DML语句
```java
/**
* 增加操作
*/
public void testInsert(){
  String sql="insert into student values(null,'decade',15)";
  Class.forName("com.mysql.jdbc.Driver");
  Connection conn=DriverManager.getConnection("jdbc:mysql:///user","root","root");
  Statement statement=conn.createStatement();
  statement.executeUpdate(sql);
  statement.close();
  conn.close();
}

/**
* 更新操作
*/
public void testUpdate(){
  String sql="update student set name='kiva' where id=1";
  Class.forName("com.mysql.jdbc.Driver");
  Connection conn=DriverManager.getConnection("jdbc:mysql:///user","root","root");
  Statement statement=conn.createStatement();
  statement.executeUpdate(sql);
  statement.close();
  conn.close();
}

/**
* 更新操作
*/
public void testUpdate(){
  String sql="delete from student where id=1";
  Class.forName("com.mysql.jdbc.Driver");
  Connection conn=DriverManager.getConnection("jdbc:mysql:///user","root","root");
  Statement statement=conn.createStatement();
  statement.executeUpdate(sql);
  statement.close();
  conn.close();
}


```

##### 关闭资源

```java
/**
	 * 创建表操作
	 * @throws Exception
	 */
	@Test
	public void testCreateTable(){
		String sql="create table student("
				+ "id bigint primary key auto_increment,"
				+ "name varchar(20),"
				+ "age int)";
		//1. 加载注册驱动
		Connection conn=null;
		Statement statement=null;
		try {
			Class.forName("com.mysql.jdbc.Driver");
			//2. 获取连接
			conn=DriverManager.getConnection("jdbc:mysql://localhost:3306/javaweb", "root", "root");
			//3. 获取预编译对象
			statement = conn.createStatement();
			statement.executeUpdate(sql);
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
      close(statement,conn);
		}


	}


public static void close(Statement statement,Connection conn){
  try {
    if(statement!=null){
      statement.close();
    }
  } catch (SQLException e) {
    e.printStackTrace();
  }
  try {
    if(conn!=null){
      conn.close();
    }
  } catch (SQLException e) {
    e.printStackTrace();
  }
}
```

##### 预编译语句对象

Statement 静态语句对象,参数不同，需要写不同的sql语句
PrepareStatement 对象:预编译语句对象，可以使用包含占位符的sql模板

步骤:
1. 获取preparement对象
2. 设置参数
3. 执行sql语句

```java
/**
* 增加操作
*/
public void testInsert(){
  // ? 表示值的占位符
  String sql="insert into student values(null,?,?)";
  Class.forName("com.mysql.jdbc.Driver");
  Connection conn=DriverManager.getConnection("jdbc:mysql:///user","root","root");

  PreparedStatement statement=conn.prepareStatement(sql);
  statement.setString(1,"decade");
  statement.setInt(2,15);

  statement.executeUpdate();
  statement.close();
  conn.close();
}
```

##### DQL 操作
需求:
1. 查询单条记录
2. 查询多条记录

```
ResultSet : 表示返回数据库查询的结果集
    getObject(int columnIndex); 根据数据的索引获取数据，从1开始
    getObject(String columnLabel); 根据数据的字段名获取数据
```
###### 代码示例
```java
public void testGet(){
  // ? 表示值的占位符
  String sql="select * from student where id=?";
  Class.forName("com.mysql.jdbc.Driver");
  Connection conn=DriverManager.getConnection("jdbc:mysql:///user","root","root");

  PreparedStatement statement=conn.prepareStatement(sql);
  statement.setObject(1,1);

  ResultSet set=statement.executeQuery();
  //如果有下一行，移动游标移动到下一行
  if(set.next()){
      Object obj=set.getObject();
  }
  set.close();
  statement.close();
  conn.close();
}


public void testGetAll(){
  List<Student> list=new ArrayList();
  // ? 表示值的占位符
  String sql="select * from student";
  Class.forName("com.mysql.jdbc.Driver");
  Connection conn=DriverManager.getConnection("jdbc:mysql:///user","root","root");

  PreparedStatement statement=conn.prepareStatement(sql);
  statement.Object(1,1);

  ResultSet set=statement.executeQuery();
  //如果有下一行，移动游标移动到下一行
  while(set.next()){
      Long id=set.getLong("id");
      String name=set.getString("name");
      Integer age=set.getInt("age");
      list.add(new Student(id,name,age));
  }
  set.close();
  statement.close();
  conn.close();
}
```


```
总结:
---mysql 排序:-----
order by 字段名 asc/desc
asc:升序   desc: 降序
示例: select * from user order by age asc

聚合函数
count（*） 查询记录数
sum(*)  查询总和
avg(字段名) 获取平均值
max(字段名) 最大值
min(字段名) 最小值

jdbc:
1. 导入数据库驱动包
  mysql-connection.jar
2. 加载注册数据库驱动
  Class.forName("com.mysql.jdbc.Driver");
3. 获取连接
  DriverManager.getConnection("jdbc:mysql://localhost:3306/数据库名","用户名","密码");
4. 获取预编译语句对象
  connection.createStatement();
  connection.prepareStatement();
5. 执行sql语句
6. 关闭资源
  close()方法，先开后闭原则
```
