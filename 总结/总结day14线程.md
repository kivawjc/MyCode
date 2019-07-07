## 线程与并发
##### 进程与线程的区别
1. 进程:一个在内存中运行的应用程序
2. 线程:线程中有多个执行任务，一个任代表一个线程,一个进程有多个线程

#### main线程
java程序运行会有俩个 线程一个main线程和一个gc回收进程

#### 线程创建
1. 创建线程类继承Thread
2. 重写run()方法
3. 创建Thread子类对象，调用start()方法

```
public class MyThread extends Thread{

  public void run(){
    System.out.println("线程创建了");
  }

}

class MyClass{
  public static void main(String[] args) {
    Thread th=new Thread();
    th.start();
  }
}
```
#### 线程实现方式创建
1. 创建类是Runnable
2. 重写run()方法
3. 创建Thread对象，传入runnable对象,调用start()方法


#### 线程特点
1. 线程之间的切换是随机的
2. 一个线程开启会执行一次run()方法
3. 开启线程使用start()方法，底层会调用该线程的run方法
4. 一个线程对象布恩那个多次开启，多次开启会报错，需要重新创建对象
  MyThread t1=new MyThread();
  t1.start();
  tv.start();

###### 操作线程的方法

### join方法
使线程之间的由并行变成串行
### sleep方法
使线程休眠一段时间
sleep(long millis);

##### 线程神奇排序
```
public class Test{
  public static void main(String[] args) {
    int[] arr=new int[]{6,10,5,2,18};
    for(int i=0;i<arr.length;i++){
      new MyThread(arr[i]).start();
    }
  }
}

class MyThread extends Thread{

  private int num;

  public MyThread(int num){
    this.num=num;
  }

  public void run(){
    sleep(num*10);
    System.out.println(num);
  }

}

```

---
#### 吃苹果案例
* 有50个苹果
* 问题描述:多个线程对象需要访问同一资源时会出现线程并发问题

#### -------Thread 实现方式-------
```
class StudentThread extends Thread{

  private static int num=50;

  public StudentThread(String name){
    super(name);
  }

  public void run(){
    String name=getName();
    while(num>0){
        System.out.print(name+"吃了一个苹果，还剩下"+--num);
    }
    System.out.print(name+"不吃了开始休息");
  }

}

class Test{
  public static void main(String[] args) {
    StudentThread a=new StudentThread("小A");
		StudentThread b=new StudentThread("小B");
		StudentThread c=new StudentThread("小C");
		a.start();
		b.start();
		c.start();
  }
}
```
#### 运行结果
```
小A开始吃苹果,剩下4
小A开始吃苹果,剩下1
小A开始吃苹果,剩下0
小C开始吃苹果,剩下2
小C不吃了，开始休息
小B开始吃苹果,剩下3
小B不吃了，开始休息
小A不吃了，开始休息
```

#### --------使用Runnable实现---------------

```
class Test{
  public static void main(String[] args) {
    //Runnable被创建了一次
    Apple apple=new Apple();
    //创建三个线程
    new Thread("小A",apple).start();
    new Thread("小A",apple).start();
    new Thread("小A",apple).start();
  }
}
class Apple implements Runnable{

  private int num=5;

  public void run(){
    //获得当前执行线程的对象
    String name=Thread.currentThread().getName();
    while(true){
      if(num>0){
          System.out.print(name+"吃了一个苹果，还剩下"+--num);
      }else{
          System.out.print(name+"不吃了");
          break;
      }
    }
  }

}
```

#### 运行结果

```
小A开始吃苹果,还剩下4个
小C开始吃苹果,还剩下2个
小C开始吃苹果,还剩下0个
小B开始吃苹果,还剩下3个
小B不吃了，开始休息
小C不吃了，开始休息
小A开始吃苹果,还剩下1个
小A不吃了，开始休息
```

#### 总结
* 继承方式

>1. java中是单继承， 如果已经有extends父类，不能再继承Thread
2. 继承方式不能多个线程共享同一个资源

* 实现方式

>1. java类可以实现多个接口
2. 多线程可以共享同一个资源

##### 线程安全问题
当多线程并发访问同一个资源对象的时候,可能出现线程不安全的问题
* 解决方式一:加上同步代码块
* 解决方式二:同步方法

##### 同步代码块
注意：在任何时候，最多允许一个线程拥有同步锁，谁拿到锁就执行，其他的线程只能在代码块外等着。
```

class Apple implements Runnable{

  private int num=5;

  public void run(){
    //获得当前执行线程的对象
    String name=Thread.currentThread().getName();
    while(true){
      //加上同步代码块,只有当一个线程执行完后,其他线程才会执行
      //必须保证同步锁对象必须是所有线程所共享的
      synchronized (this){
        if(num>0){
            System.out.print(name+"吃了一个苹果，还剩下"+--num);
        }else{
            System.out.print(name+"不吃了");
            break;
        }
      }

    }
  }

}

```


#### 同步方法

使用同步方法时，同步锁是调用当前同步方法的对象
* 对于非static方法，同步锁是this
* 对于static 方法，同步锁就是当前方法所在类的字节码对象
```
class Apple implements Runnable{

  private int num=5;

  public void run(){
    //获得当前执行线程的对象
    String name=Thread.currentThread().getName();
    while(true){
        if(!eat(name)){
          break;
        }
    }
  }
  //synchronized修饰的方法在执行的时候不会被其他线程抢占
  synchronized public boolean eat(String name){
    if(num>0){
        System.out.print(name+"吃了一个苹果，还剩下"+--num);
        return true;
    }else{
        System.out.print(name+"不吃了");
        return false;
    }
  }
}
```

##### synchronized的优劣
* 好处：保证了多线程并发访问时的同步操作，避免线程的安全性问题。
* 缺点：使用synchronized的方法/代码块的性能要低一些。
* 建议：尽量减小synchronized的作用域

#### 结论:
* 使用synchronized修饰的方法性能较低，安全性较高，反之必然
