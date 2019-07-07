
### 集合框架

###### 2019/3/20
---

#### ---集合和数组----

> * 集合:保存数组的容器
* 数组:保存相同数据的容器

数组的缺点:
    1. 长度固定
    2. 只能时同一类型
    3. 数组的操作代码复杂
集合弥补数组的缺点:
    1. 长度自动扩容
    2. 任意的类型
    3. 集合中封装方便数据操作的api

#### 数据结构
数据结构:计算机存储数据的组织方式
* 数组保存多个数据的连续空间
* 链表:每个单元保存自己的值和下一个单元的地址值
* 队列:特殊线性表-->只能操作头和尾(先进先出)
* 树:建立一个树节点，左子树的元素比右子树的节点小


##### 模拟ArrayList

1. 初始化一个数组，容量为5
2. 添加5个数据 11,22,3,44,55
3. 查询指定索引的元素
4. 替换指定索引的元素
5. 移除指定索引的元素
6. 打印出数组

```

public class PlayerList{

  //使用Integer默认值时null
  Integer[] nums=null;

  int size=0;

  //起始人数不固定
  public PlayerList(Integer size){
    nums=new Integer[size];
  }


  public PlayerList(){
    this(5);
  }


/**
* 数组添加操作
*/
  public void add(Integer ele){
    //如果超过数据容量需要进行扩容操作
    if(size==nums.length){
      nums=Arrays.copy(nums*2);
    }
    //------------------
    nums[size]=ele;
    size++;
  }


  public void delete(int index){
      if(inde<0||index>size-1){
        throw new RunTimeException();
      }
      for (int i=index;i<size-1 ;i++ ) {
          nums[i]=nums[i+1];
      }
      nums[size-1]=null;
      size--;
  }

  /**
  * 获取指定索引的数据
  */
  public Integer get(int index){
    if(inde<0||index>size-1){   //ctrl+1提取成方法
      throw new RunTimeException();
    }
    return nums[index];
  }

  /**
  * 修改指定索引的数据
  */
  public void set(int index,Integer ele){
    if(inde<0||index>size-1){
      throw new RunTimeException();
    }
    nums[index]=ele;
  }

  //重写toString打印出数据内容
  public String toString(){
      if(nums==null){
        return null;
      }
      if(nums.length==0){
        return "[]";
      }

      StringBuilder sb=new StringBuilder("[");
      for (int i=0;i<size ; i++) {
          sb.append(nums[i]);
          if(i!=size-1){
            sb.append(",");
          }
      }
      sb.append("]");
      retunr sb.toString();
  }

}


```
---

#### 数据结构的特点

1. 基于数组的数据结构查询、修改较快，添加、删除比较慢(ArrayList)
2. 基于链表的数据结构添加、删除快，查询、修改比较慢(LinkList)

#### 集合的分类
* List集合：有序，可重复
* Set集合:无序，不可重复
* Map集合:每一个元素 key-value,键不能重复，值可以重复,键相同,值覆盖
List 和 Set 继承Conllection,Map不继承Collection
---
#### ArrayList
* 需求:创建4个User对象，保存到list中
* 小结:集合保存对象时，元素保存的是对象的内存地址

```
public class User{
  private String name;
  private int age;

  public User(String name,int age){
    this.name=name;
    this.age=age;
  }
}

public class Test{
  public static void main(String[] args) {
    User u1=new User("百里守约",12);
    User u2=new User("百里守约",12);
    User u3=new User("百里守约",12);
    User u4=new User("百里守约",12);

    //list中保存的是对象的地址值
    List list=new ArrayList();
    list.add(u1);
    list.add(u2);
    list.add(u3);
    list.add(u4);
  }
}
```

#### LinkedList
* LinkedList底层采用链表算法，常适用于增删操作，有相关操作链表头尾的方法

方法|api
---|:--:|:---
addFirst(Object)|将指定元素插入到链表头
addLast(Object)|插入数据到链表尾
removeFirst()|移除链表头元素
removeLast()|移除链表结尾元素

#### Vector类
* Vector是ArraList的前身，使用synchronized修饰，线程安全，效率低

---
#### 泛型
* 可以使用泛型限制容器中只能存储相同类型的元素
* 不用泛型的情况下，默认是Object 需要进行强转

```
class Test{

    public static void main(String[] args) {
      //如果在集合中不使用泛型
      //不方便获取数据
      List list=new ArrayList();
      list.add(1);
      list.add("abc");
      list.add(new Object());

      //默认获取的数据是Object，需要向下转型
      Integer abc=(Integer)list.get(0);
      String abc=(String)list.get(1);

      //在集合中使用泛型
      List<String> list02=new ArrayList<String>();
      list02.add("2");//只能保存字符串类型
    }

}

```

#### 自定义泛型

需求:定义一个Point类，x,y属性(类型分别用String,Double,Integer作为属性类型)
步骤:
1. 定义一个类,使用 <T> 声明，表示数据类型是未知的
2. 在类中定义未知的数据类型时，使用标识符 T

```

public class Point <T>{

	private T x;
	private T y;

  public Point(T x, T y) {
		this.x = x;
		this.y = y;
	}

	public T getX() {
		return x;
	}
	public void setX(T x) {
		this.x = x;
	}
	public T getY() {
		return y;
	}
	public void setY(T y) {
		this.y = y;
	}

}

```

---
### 面试题
ArrayList 和 LinkList 的区别
> * ArrayList:底层使用数组结构,查询、修改较快，添加、删除比较慢(ArrayList)
* LinkList:底层使用链表结构,添加、删除快，查询、修改比较慢(LinkList)

ArrayList 和Vector 的区别
> * Vector类是ArrayList的前身，使用synchronized修饰,属于线程安全,效率低
* ArrayList 线程不安全，效率高
