## 异常
Throwable 是Error和Exception的父类
```
Throwable
  |---Error(错误不处理)
  |---Exception(异常需要处理)
    |---运行时异常
        |--RunTimeException及其子类
    |---编译时异常
        |---(除了 RuntimeException 以及子类 以外，其他的 Exception及其子类)
```
### Error
Error 表示代码运行JVM虚拟机出现的问题,如系统崩溃和溢出，不做处理
#### Exception
* 程序运行时出现的不正常的现象

#### 异常处理
* 直接处理异常(捕获)
* 直接抛出异常，不做处理,往上抛出
* 捕获的时候，捕获完成，不影响后续代码的执行,抛出

---
### ----  try catch  -----
* 使用格式
```
try{
    有可能出现异常的代码
}catch(异常类型 异常对象名){
    处理捕获到异常的代码
}
```

##### 访问异常信息
* String getMessage(); 返回异常信息
* void printStackTrace(); 打印异常信息，异常类型名和异常出现的位置

##### 示例代码
```
public class TestTry{
  public static void main(String args){
      System.out.println("开始");
      divede(10,0);
      System.out.println("结束");
  }
  /**
  * 除法
  **/
  public static void divide(int a,int b){
      // alt + shift +z  快速生成处理异常代码
      try{
        System.out.println(a/b);
        //此行代码不会执行
        System.out.println("try...异常后");
      }catch(ArithmeticException e){
         System.out.println("除法运算有错误");
      }
      //会执行
      System.out.println("catch执行后");
  }
}
```
运行结果:
```
开始
除法运算有错误
catch执行后
结束
```
###### 注意:
* 在当前位置处理异常后，不会中断程序，继续往下执行
* 当不知道异常的类型时，可以使用Exception
* 当出现异常时,try 中异常后面的代码不会执行,catch执行后面的代码会执行

---
##### 捕获多个异常
* 作用:当出现多个异常
* 格式
```
try{
    有可能出现异常的代码
}catch(异常类型A 变量){
    异常类型A处理的代码
}catch(异常类型B 变量){
    异常类型B处理的代码
}
```
* 示例代码
```
public class TestTry02{
  public static void main(String args){
      System.out.println("开始");
      divede("4","0");//除数为0会有算数异常
      divede("4","abc");//数据格式转换异常
      System.out.println("结束");
  }
  /**
  * 除法
  **/
  public static void divide(String a,String b){
      int num1=Integer.parseInt(a);
      int num2=Integer.parseINt(b);
      try{
        System.out.println(num1/num2);
      }catch(ArithmeticException e){
         System.out.println("除法运算有错误");
      }catch(NumberFormatException e){
         System.out.println("数据格式化异常");
      }catch(Exception e){  //Exception异常放在最后
        System.out.println("Exception异常");
      }
  }
}
```
###### 注意:
* 在当前位置处理异常后，不会中断程序，继续往下执行
* 捕获多个异常时，先捕获子类异常，再捕获父类异常
---
##### try-catch-finally
* 作用:最终都会执行的代码
* 格式:

```
try{
    可能抛出的异常代码
}catch(异常类型 变量){
    处理异常代码
}finally{
    无论有没有异常都会执行
}

```
* 示例代码

```
public class TestFinally{

  @Test
	public void test(){
		try {
			divide(1,0);
			System.out.println("try语句之后");//不会执行
		} catch (Exception e) {
			System.out.println(e.getMessage());
			return;//使用return之后，依旧会执行finally
		}finally {
			System.out.println("finally代码块执行");//会执行
		}
		System.out.println("catch之后");//不会执行
	}

	public static void divide(int a,int b){
		System.out.println("a/b="+(a/b));
		System.out.println("catch()执行结束");
	}

}
```
##### 运行结果
```
/ by zero
finally代码块执行
```

#### 总结:
> * try 块必须和 catch块或 try 和finally 同在，不能单独存在try 或 catch或finally
* 如果再try-catch语句中执行System.exit(0);，此时finally不会执行
* 一般将关闭资源的操作写在finally{}中，保证资源能关闭

---

### 抛出异常

##### throws 关键字
* 在有可能出现异常的方法上声明抛出可能出现的异常类型
* 当方法内部处理不了异常时，需要将方法往上抛出，提醒调用者需要处理该异常
* 可以抛出多个异常类型，使用 , 隔开

```
public class Test_Demo{

  public static void main(String[] args){
    System.out.println("开始");
    try{
      divede("4","0");
    }catch(ArithmeticException e){
      e.printStackTrace();
    }
    System.out.println("结束");
  }

  public static void divide(int a,int b) throws ArithmeticException{
		System.out.println("a/b="+(a/b));
		System.out.println("divide方法执行结束");//当出现问题，这个代码没有执行
	}

}
```
###### 运行结果
```
开始执行
除法算数异常
执行结束
```


#### throw 关键字
* 在方法内需要返回一个错误结果给调用者，使用thrrow在方法内手动抛出异常


```
public class ThrowDemo{

    public static void main(String[] args) {
      try {
        isExist("decade");
      } catch(Exception e) {
        e.printStackTrace();
      }
    }

    //手动抛出异常是为了保证数据安全处理
    public static boolean isExist(String uName) throws Exception{
        String[] data={"decade","kiva","kabuto"};

        //异常数据判断--->业务异常
        //数据出现问题，后面业务逻辑不再执行
        if (uName==null&&uName.trim().length==0) {
          throw new Exception();
        }
        //正常业务逻辑
        for(String name:uName){
          if (name.equals(uName)) {
              return true;
          }
        }
        return false;
    }

}
```

---

#### 异常的分类

>* 运行异常:在编译时期不被检测，在程序运行时期出问题
        |--extends RunTimeException
* 编译异常:在编译时期出问题,不管数据对不对都会提醒
      |--除了RunTimeException及其子类,其他都属于编译异常
          |---ParseException (SimpleDateFormat.parse())


---

#### 自定义异常类
```
1. 继承Exception或RunTimeException
      |--RunTimeException不会编译时期提示异常
2. 提供一个无参构造和带参构造
```

```
class Customer{
  private String name;
  private int age;
  public Customer(String name,int age)throws AgeException{
    this.name=name;
    if(age<0){
      throw new AgeException("年龄字段非法");
    }
    this.age=age;
  }
}

/**
* 自定义一个异常
*/
class AgeException extends Exception{
  public AgeException(){}
  public AgeException(String message){
    super(message);
  }
}

class Demo{
  public static void main(String[] args) {
    try {
        //年龄非法抛出异常
        Customer c=new Customer("decade",-15);
    } catch(AgeException e) {
        e.printStackTrace();
    }

  }
}
```


### 面试题
>throw 和 throws的区别
*  throws ： 用于方法的声明上，表示方法不处理某类型异常，提醒调用者需要处理该异常
*  throw : 用于返回一个错误结果，抛出具体异常类给调用者
* throw ---> 抛出异常 ---> 在方法上----> 加异常对象
* throws---> 声明异常 ---> 在方法声明上->加异常类型

> final 和 finally 和 finalize 三者的区别
* final:最终的不可修改的
* finally：在异常处理中，表示最终会执行
* finalize:对象被销毁时自动执行的方法

#### finalize 代码示例
```
class A{
  public static void main(String[] args) {
    //不断创建对象会被不断销毁
    while(true){
      new TT();
    }
  }
}
class TT{
  protected void finalize() throws Throwable{
    System.out.println("我被销毁了");
  }
}
```

###### 运行结果
```
我被销毁了
我被销毁了
我被销毁了
我被销毁了
....
```
