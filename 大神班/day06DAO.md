## DAO结构设计
---
#### DAO概述:
* 是一个数据库访问接口,操作数据库,在业务逻辑层和数据库资源中间

#### dao 设计
需求:对学生表记录进行增删改查

```
dao 层: 实现对数据库增删改查的规范
    |----xxx.dao 存放接口  IStudnetDAO
    |----xxx.dao.impl 存放实现类StudnetDaoImpl
IStudnetDAO:

void save(Student stu);   保存数据
void delete(Long id); 删除数据
void update(Student stu); 更新数据
Student get(Long id);     查询单条记录
List<Student> getAll();    查询多条记录

domain层:描述数据库结构的javabean
    |----xxx.domain 存放javabean

测试类: 通过接口生成测试类
    |---xxx.test  存放StudentDaoTest
工具类: 存放工具
    |---xxx.util StringUtil/JDBCUtil
```

#### dao开发流程
1. 设计数据库表 Student
2. 导入mysql驱动包
3. 根据数据表创建 domain javabean类
4. 创建dao 以及接口
5. 根据dao接口生成实现类
6. 根据接口生成测试类

###### 1. 设计数据库表 Student
```
create table student(
id bigint primary key auto_increment,
name varchar(20),
age int
);
```
###### 2. student类
```
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@ToString
public class Student {

	private Long id;
	private String name;
	private Integer age;
}
```
###### 3. 创建dao 接口

```
public interface IStudentDao{

  void save(Student stu);

  void delete(Long id);

  void update(Student stu);

  Student get(Long id);

  List<student> getAll();
}
```
###### 4. 创建dao实现类
```
public class StudentImpl implements IStudentDao{
  void save(Student stu){
      String sql="insert into student values(null,?,?)";
      try{
        Class.forName("com.mysql.jdbc.Driver");
        //获取连接
        Connection conn=DriverManager.getConnection("jdbc:mysql:///javaweb","root","root");

        PrepareStatement ps=conn.prepareStatement(sql);
        ps.setString(1,stu.getName());
        ps.setInt(2,stu.getAge());

        ps.executeUpdate();
      }catch(Exception e){
        e.printStackTrace();
      }finally{
        JDBCUtil.close(null,ps,conn);
      }
  }

  void delete(Long id){
    String sql="delete from student where id=?";
    try{
      Class.forName("com.mysql.jdbc.Driver");
      //获取连接
      Connection conn=DriverManager.getConnection("jdbc:mysql:///javaweb","root","root");

      PrepareStatement ps=conn.prepareStatement(sql);
      ps.setString(1,id);

      ps.executeUpdate();
    }catch(Exception e){
      e.printStackTrace();
    }finally{
      JDBCUtil.close(null,ps,conn);
    }
  }

  void update(Student stu){
    String sql="update student set name=?,age=? where id=?";
    try{
      Class.forName("com.mysql.jdbc.Driver");
      //获取连接
      Connection conn=DriverManager.getConnection("jdbc:mysql:///javaweb","root","root");

      PrepareStatement ps=conn.prepareStatement(sql);
      ps.setObject(1,stu.getName());
      ps.setObject(2,stu.getAge());
      ps.setObject(3,stu.getId());

      ps.executeUpdate();
    }catch(Exception e){
      e.printStackTrace();
    }finally{
      JDBCUtil.close(null,ps,conn);
    }
  }

  Student get(Long id){
    String sql="select * from student where id=?";
    try{
      Class.forName("com.mysql.jdbc.Driver");
      //获取连接
      Connection conn=DriverManager.getConnection("jdbc:mysql:///javaweb","root","root");

      PrepareStatement ps=conn.prepareStatement(sql);
      ps.setString(1,id);

      ResultSet rs=ps.executeQuery();
      if(rs.next()){
        String name=rs.getString("name");
        int age=rs.getInt("age");
        Student stu=new Student(id,name,age);
        return stu;
      }
    }catch(Exception e){
      e.printStackTrace();
    }finally{
      JDBCUtil.close(null,ps,conn);
    }
    return null;
  }

  List<student> getAll(){
    List<Student> list=new ArrayList<>();
    String sql="select * from student";
    try{
      Class.forName("com.mysql.jdbc.Driver");
      //获取连接
      Connection conn=DriverManager.getConnection("jdbc:mysql:///javaweb","root","root");

      PrepareStatement ps=conn.prepareStatement(sql);
      ps.setString(1,id);

      ResultSet rs=ps.executeQuery();
      while(rs.next()){
        String name=rs.getString("name");
        int age=rs.getInt("age");
        Long id=rs.getLong("id");
        list.add(new Student(id,name,age));
        return list;
      }
    }catch(Exception e){
      e.printStackTrace();
    }finally{
      JDBCUtil.close(rs,ps,conn);
    }
    return list;
  }
}
```
###### 5. 创建测试类
```
public class StudentDaoTest{

  private IStudentDao dao=new StudentDaoImpl();

  public void testSave(){
    Student stu=new Student(null,"decade",18);
    dao.save(stu);
  }

  public void testDelete(){
    dao.delete(1L);
  }

  public void testUpdate(){
    Student stu=new Student(1L,"kiva",18);
    dao.update(stu);
  }

  public void testGet(){
      Student stu=dao.get(1L);
      System.out.println(stu);
  }

  public void testGetAll(){
    List<Student> list=dao.All();
    System.out.println(list);
  }

}
```
###### 6.创建jdbc工具类
```
public class JDBCUtil{

  private static String dirverClass;
  private static String url;
  private static String user;
  private static String password;

  static{
    InputStream in=Thread.currentThread()
    .getClassLoader()
    .getResourceAsStream("db.properties");

    Properties ps=new Properties();
    ps.load(in);

    dirverClass=ps.getProperty("dirverClass");
    url=ps.getProperty("url");
    user=ps.getProperty("user");
    password=ps.getProperty("password");

    Class.forName(dirverClass);
  }

  public static Connection getConnection(){
    try{
      return DriverManager.getConnection(url,user,password);
    }catch(Exception e){
      e.printStackTrace();
    }
    throw new RunTimeException("数据库创建失败");
  }

  public static void close(ResultSet set,Statement statement,Connection conn){
    try {
      if(set!=null){
        set.close();
      }
    } catch (SQLException e) {
      e.printStackTrace();
    }
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
}

```

###### db.properties
```
dirverClassName=com.mysql.jdbc.Driver
url=jdbc:mysql:///javaweb
username=root
password=root
```

##### 抽取jdbcUtil
1. 抽取连接数据库的四个参数到工具类中,使用配置文件
2. 使用静态代码块加载注册驱动 Class.forName()只执行一次
3. 数据库增删改操作只有sql语句不同,和参数不同
4. 需要建立一个数据库连接池，保存connection重复使用


##### sql 注入问题
sql 注入:通过传递参数，将sql语义进行更改，称为sql注入
```
演示登陆场景SQL注入问题
步骤:
1. 创建一张user表  id  username  passoword
2. 根据用户数据查询数据库是否记录
    selct * from user where username='root' and password='123';
3. 使用statement会出现sql注入问题
4. 使用prepareStatement不会出现sql注入问题

/**
* sql 语义发生变化，可能出现sql注入问题
*/
public void testStatement(){
  Connection conn=JDBCUtil.getConnection();
  Statement statement=conn.createStatement();
  String sql="selct * from user where username='root' and password='123'";
  //sql注入成功登陆 ----> sql语义发生改变
  // 条件是 username为空 or 1=1  or 密码是 admin
  String sql="selct * from user where username=''or 1=1 or'' and password='123'";
  ResultSet rs=statement.executeQuery(sql);
  if(rs.next()){
    System.out.println("登陆成功");
  }else{
    System.out.println("登陆失败");
  }
}

/**
* sql 语义已经固定，不会发生sql语句
*/
public void testPrepareStatment(){
  Connection conn=JDBCUtil.getConnection();
  PreparedStatement ps=conn.prepareStatement();
  //模板固定之后，SQL的语义已经固定，只将传递的参数当作字符内容去查询
  String sql="selct * from user where username=? and password=?";
  ps.setObjec(1,"root");
  ps.setObjec(2,"123");
  ResultSet rs=statement.executeQuery(sql);
  if(rs.next()){
    System.out.println("登陆成功");
  }else{
    System.out.println("登陆失败");
  }
}

```


```
总结；
dao 层:封装对数据库进行操作的规范
  |---xxx.dao IStudentDao
    |--save , delete , update , select
  |---xxx.dao.Impl studentDao
domain层:封装对应数据库表数据关系的javabean对象
test : 测试dao接口的类
util : 工具类

步骤:
1. 创建数据表
2. 导入mysql驱动包
3. 在domain中创建javabean
4. 创建dao接口和实现类
5. 创建测试类

重构:
1. 数据库获取连接的4个参数，使用读取配置文件，解决硬编码
2. 封装获取连接的方法,使用连接池保存

prepareStatement 使用:
1. 使用prepareStatement语法简单
2. 对sql语句模板进行缓存

sql 注入:
1. 使用prepareStatement 固定了sql语句的语义，不会产生sql注入问题
```
