## 注解&内省


### 为什么使用注解
* 使用xml配置需要做大量的工作,会导致xml代码臃肿
* 可以使用注解来解决xml配置臃肿的问题

### 什么是注解
* 在java5之后，开始对元数据进行支持,可以用来描述其他数据的一种数据
* 使用接口 Annotation表示注解

### 常见的注解

```java
@Test : 用来描述一个测试方法，具备可以测试的功能
@Override: 限定覆写父类方法
@SuppressWarings :抑制编译器发出的警告,@SuppressWarings(value="all")
@Deprecated : 标记是过时的Api
```

### 注解的定义格式
```java
public @interface Override{

}
```

### 注解的使用语法

@ 注解名(属性名1=值1,属性名2=值2)


### 为什么注解可以具有一些功能
* 需要有三方程序通过反射给注解赋予功能
例如，重写方法是三方程序通过反射获取方法所在类的父类是否具有这个方法，如果没有编译不通过

### 元注解
* 注解:用来约束其他程序的(方法，字段等)
* 元注解:元注解是用来约束注解的注解（包括约束注解可以修饰的位置,注解保存的时期）

```java
@Target:表示注解可以用来贴在哪个位置
ElementType.FIELD :只能修饰字段
ElementType.METHOD:修饰方法
ElementType.PARAMETER:修饰参数
ElementType.TYPE:修饰类，接口

@Retention：注解保存的时期
SOURCE  : 源码时期,能在源码中存在
            |---辅助编译，写源码时有作用
CLASS   : 字节码时期,能在字节码中存在
RUNTIME : 运行时期存在; 源码，字节码(编译)，运行时期都存活

如果要用反射给注解赋予功能使用RUNTIME,自定义注解都要使用这个值
```

## 自定义注解
需求:

语法格式:
1. 在注解中，抽象方法名不叫方法名是属性名，返回值是属性值的类型
2. 可以给属性值赋初始值 default
3. 如果必须要写的属性名是value,只有一个属性时,可以省略属性名
4. 数组类型，值需要用{}
5. 属性类型只能使用基本数据类型，String,Class,注解，枚举等，不能使用void

```java
@Target(ElementType.TYPE)
@Retention(RetentionPolicy.RUNTIME)
public @interface VIP{
  int age() default 18; //属性名和属性值的类型
  String name() default "decade";
  int value();
  String[] hobby();
}

@VIP(age=1,name="decade")
public class User(){

}
//省略value
@VIP(10)
public class User(){

}

//使用数组需要使用{},只有一个值时可以省略
@VIP(hobby={"aa","bb"})
public class User(){

    public void test(){
      Class clz=User.class;
      VIP anno=clz.getAnnotation(VIP.class);
      if(anno!=null){
        int age=anno.age();
        System.out.println(anno.age());
        System.out.print(anno.value());

        if(age<18){
          System.out.print("不约");
        }else{
          System.out.print("约");
        }
      }
    }
}
```

### 注解和xml的选用
* 使用注解可以取代臃肿的xml配置文件
* 使用注解做配置其实是一种硬编码的方式


## javabean
#### 什么是javabean
在java中常见的可重用的组件,遵循一定的规范

1. 类必须使用public修饰
2. 必须提供公共的无参的构造器
3. 字段都是私有化的
4. 提供get/set方法

#### javabean中重要成员:
  * 方法
  * 属性(property)

* 字段是成员变量，属性是get/set方法推导出的
* 标准的set/get方法，去掉set/get,首字母小写

## 内省
* 在JDK中，提供了一个专门用来操作javabean的属性的工具类 Introspector

核心类:Introspector，可以获取javabean的方法，事件和属性

#### 常见Api
```java
Introspector : 获取javabean的描述信息
    |----getBeanInfo(Class<?> beanClass)
    |----getBeanInfo(Class<?> beanClass,Class<?> stopClass) : 只包含到哪个父类为止的属性
BeanInfo : 获取属性描述器
    |----PropertyDescriptor[] getPropertyDescriptors()
PropertyDescriptor : 获取属性名/属性类型/读写方法
    |---getPropertyType()
    |---getReadMethod()  获取get方法
    |---getWriteMethod()  获取set方法
    |---getName() 获取属性名
```

#### 示例代码
```java
class Person{

    private String name;
    private int age;

    set/get

}


class IntrospectorTest{

  public void testGetBeanInfo(){

      Person p=Person.class.newInstance();

      //获取javabean描述信息
      BeanInfo beanInfo=Introspector.getBeanInfo(Person.class,Object.class);
      //获取属性描述器
      PropertyDescriptor[] pds=beanInfo.getPropertyDescriptors();

      for(PropertyDescriptor p:pds){

          System.out.print(p.getName());
          System.out.print(p.getPropertyType());
          System.out.print(p.getReadMethod());
          System.out.print(p.getWriteMethod());

          // 使用内省，给属性设置值
          Stirng propertyName=p.getName();
          Method m=p.getWriteMethod();//set方法
          if("age".equals(propertyName)){
               m.invoke(p,10);
          }else if("name".equals(propertyName)){
               m.invoke(p,"decade");
          }
      }

      System.out.print(p);
  }

}
```

### javabean 和 map 的转换

#### 为什么要把javabean和bean进行转换
场景:在web开发中，请求参数封装到Map中，需要将map装成数据bean类

```java
class BeanUtil{

    private BeanUtil(){}

    public static Map<String,Object> bean2map(Object obj){
      /**
      需求:将javabean对象中的属性值封装到Map中
        1. 使用内省获取javabean的属性值
        2. 将属性值设置到map中

      */
      Map<String,Object> map=new HashMap();
      BeanInfo beanInfo=Introspector.getBeanInfo(obj.class,Object.class);
      PropertyDescriptor[] pds=beanInfo.getPropertyDescriptors();
      for(PropertyDescriptor p:pds){
          Method m=p.getReadMethod();
          Object value=m.invoke(obj);//get方法 返回值是属性值
          String key=p.getName();

          map.put(key,value);
      }
      return map;
    }



    public static <T> T map2Bean(Map<String,Object>  map,Class<T> clz){
      /**
        获取Map中的属性封装到javabean中
        1. 需要传入clz,遍历对应的
            属性名和属性
        2. map.get(属性名)
      */
      Object obj=clz.newInstance();

      BeanInfo beanInfo=Introspector.getBeanInfo(clz,Object.class);
      PropertyDescriptor[] pds=beanInfo.getPropertyDescriptors();

      for(PropertyDescriptor p:pds){
          String key=p.getName();
          Object value=map.get(key);

          Method m=p.getWriteMethod();
          m.invoke(obj);//set方法
      }

      return obj;
    }



}
```

```
总结:
1> 什么是注解
 注解是用来约束程序功能的描述器,使用注解可以解决代码臃肿的问题
2>常见的注解


注解的优缺点:
1> 使用注解可以解决代码臃肿的问题
2> 使用注解会导致硬编码问题

什么是javabean
在java中常见的可重用的组件,遵循一定的规范

1. 类必须使用public修饰
2. 必须提供公共的无参的构造器
3. 字段都是私有化的
4. 提供get/set方法

内省
在JDK中，提供了一个专门用来操作javabean的属性的工具类
```
