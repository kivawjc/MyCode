## 反射机制


## junit 单元测试
操作步骤:
1. 导入junit4包
2. 定义一个公共无参无返类型的方法
3. 添加 @Test 注解

注意：
1. 只要有一个测试方法不规范，都不能运行
2. 测试状态条要在断言的时候才有意义

根据接口生成测试类
new  ---> juint test case,先完成测试类，再去具体的实现

```java
public interface IMath{
  void add(int a,int b);
  void sub(int a,int b);
}


public class MathImpl implements IMath{

	@Override
	public int add(int a, int b) {
		return a+b;
	}

	@Override
	public int sub(int a, int b) {
		return a-b;
	}

}


public class TestMath {

	IMath math=new MathImpl();

	@Test
	public void testAdd() {
		System.out.println(math.add(10, 20));
	}

	@Test
	public void testSub() {
		System.out.println(math.sub(30, 20));
	}

}
```

#### 断言
断言: 猜测一个真实结果是否时期望结果

```java
int ret=math.add(3,4);
//期望值  和 结果是否相等 ,不相等时直接报错
Assert.assertEqual(7,ret);
Assert.assertEqual("断言错误信息",7,ret);

//期望该方法报错ArithmeticException
@Test(expected=ArithmeticException.class)
public void testDiv(){

}
```

### 测试前/后
在测试方法之前需要初始化，测试方法之后需要销毁操作

```java
@Test
public void testQuery(){
  System.out.print("查询用户信息");
}

所有测试方法之前都会执行的代码
@Before
public void init(){
  System.out.println("登陆操作");
}

所有测试方法之后都会执行的代码
@After
public void destroy(){
  System.out.print("注销操作");
}

所有操作之前，只执行一次
@BeforeClass
public static void beforeClass(){
  System.out.print("所有操作之前");
}

所有操作之后，只执行一次
@AfterClass
public static void afterClass(){
  System.out.print("所有操作之后");
}
```

## 反射
#### 为什么使用反射

* 使用反射技术，可以通过一个对象，获取他真实类型
* 通过反射机制，根据类的信息创建对应的对象

```java
class Person{
  public Object work(){
    return new Date();
  }
}

public static void main(String[] args) {
  Person p=new Person();
  Object obj=p.work();
  //不能调用子类的方法------> 不清除其真实类型
  obj.toLocalString();
}
```

### 什么是反射
* 程序运行过程中，通过字节码对象，去动态获取该字节码中的成员信息(构造器，方法，字段，包)

### 什么是字节码对象
类:多个具有相同特性的事物的抽取
Class类:在JVM中的一份份字节码文件,用来描述类的类(字节码对象的类型Class)
```java
public class Class{
  Construtor con;
  Method method;
  Field field;
  ...
}
```
> 结论:
字节码对象就是用来描述JVM中字节码文件的结构,可以获取字节码的成员信息

---
### 获取Class对象
字节码对象是JVM加载字节码文件的时候才会创建的对象

1. 通过class类的forName方法来获取
public Class forName(类的全限定名);根据全限定名来获取字节码对象
    全限定名：包名+类名
2. 使用对象getClass()方法
3. 任何类型都有一个class属性
4. 不管以任何方式获取到同一个类型的字节码对象，都是同一个对象

```java
public void testGetClass(){
    //1. 通过forName静态方法获取
    Class clazz=Class.forName("类的全限定名");

    //2. 通过对象.getClass
    Object obj=new Object();
    Class cls1=obj.getClass();

    //3. 使用class属性
    Class cls2=Person.class;

    System.out.print(int.class=Integer.class);
    System.out.print(int.class=Integer.TYPE);
    System.out.print(String[].class);
}
```
---

### 获取构造器
构造器|含义
---|:--:|:---
getConstructor(Class... paramType)|获取public修饰的指定构造器
getDeclaredConstructor(Class... paramType)|获取不管权限的构造器
Constructor<?>[] getConstructors()|获取public修饰的所有构造器
Constructor<?>[] getDeclaredConstructors()|获取不管权限的所有构造器


需求:
1. 获取所有public构造器
2. 获取所有的构造器包括private
3. 获取无参数的构造器
4. 获取指定参数的public的构造器
5. 获取指定参数的private的构造器


```java
1. 获取所有public构造器
Class cls=Person.class;
Construtor[] cs=cls.getConstructors();

2. 获取所有的构造器包括private
cs=cls.getDeclaredConstructors();

3. 获取无参数的构造器
Construtor c=cls.getConstructor();

4. 获取指定参数的public的构造器
Construtor c=cls.getConstructor(Long.class,String.class,int.class);

5. 获取指定参数的private的构造器
Construtor c=cls.getDeclaredConstructor(String.classf,int.class);
```

### 通过构造器创建对象

```
类:AccessibleObject(父类)
    |---Construtor
    |---Field
    |---Method
setAccessible(flag)设置私有变量可以访问
```

```java
Class<Person> clazz=Person.class;

1. 调用空参构造
Construtor<Person> conn=clazz.getConstructor();
Person p=conn.newInstance();

2. 调用带参构造
Construtor<Person> conn=clazz.getConstructor(Long.class,String.class);
Person p=conn.newInstance(100L,"decade");

3. 获取私有构造并创建对象(不能直接访问私有构造器)
con=clazz.getDeclaredConstructor(String.class,int.class);
con.setAccessible(true);
p=con.newInstance();

4. 使用字节码对象直接调用无参构造器
Person p=clazz.newInstance();
```

---

### 方法
Method getDeclaredMethod(String name, Class<?>... parameterTypes)

```java
public void getMethod(){
  1. 获取所有public方法，包括继承的
  Class clz=Person.class;
  Method[] ms=clz.getMethods();

  2. 获取所有方法，包括private，不包括继承的
  Method[] ms=clz.getDeclaredMethods();

  3. 获取指定方法，包括继承
  Method m=clz.getMethod("getSum",1,2);

  4. 获取指定方法，包括private
  Method m=clz.getDeclaredMethod("getSum",1,2);

}

public void testInvoke(){

  Class clazz=Person.class;
  Object obj=clazz.newInstance();

  1. 执行无参无返回的方法
  Method m=clazz.getMethod("method1");
  Object ret=m.invoke(obj);

  2. 有参数无返回
  Method m=clazz.getMethod("method2",String.class);
  Object ret=m.invoke(obj);

  3. 调用私有方法
  Method m=clazz.getDeclaredMethod("method2",String.class);
  m.setAccessible(true); //设置允许访问
  Object ret=m.invoke(obj);
}
```
---



## 加载配置文件
### 为什么使用配置文件
* 抽取常用配置信息到配置文件中，修改只需要修改配置文件，不需要修改源码,解决代码中的硬编码问题
* 硬编码:写死在java源码中，经常改动的值

### 常用配置文件

1. properties文件

```properties
# 后缀名是.properties,格式是key=value, 不能出现多余的空格
# user.properties
name=root
password=root
```

2. xml文件

文件后缀名 .xml,用清晰的格式保存复杂的数据

```xml
<!-- user.xml   -->
<beans>
  <bean name="" class="">
      <property></property>
  </bean>
  <bean name="" class="">
      <property></property>
  </bean>
</beans>
```

### 加载配置文件

步骤:
1. 在source folder中创建一个properties文件，填充数据
  * |-- source folder会自动将文件放到编译目录 bin中
2. 使用代码获取文件数据 Properties
  * |--Properties load(InputStream in):输入流将数据加载到properties对象
  * |--getProperty(key) : 获取配置文件属性内容


** user.properties **
```properties
# 注释: 数据格式key=value
# 左右不能有空格
# 读取到java文件后都是字符串类型

name=root
password=root
```

**  java代码加载并读取配置文件  **

```java
public class TestProperties{

  public void loadProperties(){
    // 方式一:使用绝对路径加载
    Properties ps=new Properties();
    InputStream in=new FileInputStream("user.properties");
    ps.load(in);//加载
    System.out.println(ps.getProperty("name"));//获取属性

    //方式二:使用类加载器
    //1. 通过当前线程对象，使用相对路径，获取流
    ClassLoader classLoader=Thread.currentThread().getContextClassLoader();
    InputStream in=classLoader.getResourceAsStream("user.properties");
    ps.load(in);//加载

    //2. 使用当前类的类加载器
    ClassLoader classLoader=TestProperties.class.getClassLoader();
    InputStream in=classLoader.getResourceAsStream("user.properties");
    ps.load(in);//加载

  }
}

```

####  总结
1. 使用相对路径-相对于当前加载资源文件的字节码路径


#### 使用反射加载配置文件
```java
interface IMath{

}
class MathImpl implements IMath{

}

public static void main(String[] args) {
  Properties ps=new Properties();
  ClassLoader classLoader=Thread.currentThread().getContextClassLoader();
  InputStream in=classLoader.getResourceAsStream("math.properties");
  ps.load(in);//加载
  IMath math=Class.forName(ps.getProperty("className")).newInstance();
}

----math.property文件----

className=IMath的完整类名
```

#### @ 反射的优缺点

优点:
1. 反射提高了程序的灵活性和扩展性
2. 允许创建多个类,解决硬编码问题

缺点:
1. 运行时解析字节码，效率低
---


### 总结:

```

Juint测试:
使用场景:主要用来测试接口实现方法,测试每个方法的功能模块
使用步骤:
1. 导包
2. 书写公共无参无返回的测试方法
3. 添加@Test注解

为什么使用反射
*可以通过反射获取对象类型的字节码信息

什么是字节码对象
1. 在程序运行时，在JVM中的一份份字节码文件，用来描述类的类
2. 通过Class类可以获取字节码对象的字节码信息,需要程序中有字节码对象，才能获取到对应的字节码信息
3. Class类是用于描述字节码信息的对象

获取Class对象
1. 使用Class的forName()静态方法
2. 使用对象的getClass()方法
3. 使用类型的class属性

使用反射获取类的构造器
getConstructor(参数类型)  获取指定的构造器
getConstructors() 获取所有公共的构造器
getDeclaredConstructor(参数类型) 获取指定私有的构造方法
getDeclaredConstructors()   获取所有的公共

调用newInstance()创建对象

使用反射获取类的方法
getMethod(方法名,参数类型) 获取指定公共方法，包括继承
getMethods()  获取所有的公共方法
getDeclaredMethod(方法名,参数类型)  获取指定方法，包括私有方法,不包括继承
getDeclaredMethods()  获取所有的私有方法

方法的调用
m.invoke(类对象,实参);
私有方法，需要设置允许访问 setAccessible();
```
