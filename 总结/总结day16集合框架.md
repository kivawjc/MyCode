## 集合框架(二)
---
#### List集合的遍历

* 使用for循环遍历集合
* 使用for-each循环
* iterator 迭代遍历

小结:
foreach底层使用迭代器
```
class Demo{

  public static void main(String[] args) {

    List<String> list=new ArrayList<String>();
    list.add("后羿");
    list.add("百里守约");
    list.add("百里玄策");

    for (int i=0;i<list.size();i++) {
      System.out.println(list.get(i));
    }

    for (String temp : list) {
      System.out.print(temp);
    }

    //-------迭代器遍历删除
    Iterator<String> iterator=list.iterator();
    while(iterator.hasNext()){
        System.out.println(iterator.next());
    }
  }
}
```

##### 并发修改异常
需求:在迭代集合的中删除指定的元素

并发修改异常
>* 使用for-each遍历的过程中，移除元素会出现并发修改异常，不予许在遍历时修改集合的长度,
* 集合将数据委托给迭代器使用，但是集合又单方面的修改数据的长度，迭代器无法获取2.，导致数据不同步
* 解决方法:
  使用迭代器遍历数据，使用迭代器修改数据

```
class Demo{

  public static void main(String[] args) {

    List<String> list=new ArrayList<String>();
    list.add("后羿");
    list.add("百里守约");
    list.add("百里玄策");

    //-----会出现并发修改问题
    for (String temp : list) {
      if(temp.equals("后羿")){
        list.remove(temp);
      }
    }

    //-------迭代器遍历删除
    Iterator<String> iterator=list.iterator();
    while(iterator.hasNext()){
        String name=iterator.next();
        if(name.equals("后羿")){
          iterator.remove();
        }
    }

  }
}
```

---

##### Set接口
Set集合的特点:
* 不允许元素重复
* 不记录添加顺序(无序)

```
public class HashSetDemo{

  public static void main(String[] args) {
    Set<String> set=new HashSet<String>();

    set.add("白起");
    set.add("亚瑟");
    set.add("亚瑟");
    set.add("亚瑟");

    set.remove("白起");

    //------如何获取set集合的数据
    //------使用迭代器遍历
    for (String temp : set) {
      System.out.print(temp);
    }

  }

}
```

##### HashSet 保存去重分析
去重原理:
如果将对象添加到set集合中
>先获取对象的hashcode值，将对象的hash值和hash表进行比对
* hash值不存在，没有重复对象，直接添加对象
* hash值存在，有可能出现重复，调用对象的equals()方法来比较
    * equals()==true，出现重复，不添加
    * equals()==false,不重复，：存储在之前对象同槽位的链表上

总结：
* 往set集合中添加对象，去重规则是比较hashcode和equals()
* 如果需要按对象内容进行去重，需要在对象中重写hashCode和equals()

```
class User{

  private String name;
  private Integer age;

}

class Demo{

  public static void main(String[] args) {
    Set<User> set=new HashSet<User>();

    // u1 和 u2 内容相同，地址值不同
    User u1=new User("decade");
    User u2=new User("decade");

    set.add(u1);
    set.add(u2);

    System.out.println(set);
  }

}
```
---
#### TreeSet
TreeSet 可以进行排序的集合，从小到大排序

```
class Demo{

  public static void main(String[] args) {
    Set<Integer> set=new TreeSet<Integer>();

    set.add(10);
    set.add(5);
    set.add(14);

    System.out.println(set);
  }

  public void testDate(){

    Set<Date> set=new TreeSet<Date>();

    Date d1=new Date(1990-1900,2-1,1);
    Date d2=new Date(2010-1900,2-1,1);
    Date d3=new Date(2019-1900,2-1,1);

    set.add(d1);
    set.add(d2);
    set.add(d3);

    System.out.println(set);

  }

}
```

### Comparable接口实现排序

比较规则，拿当前元素和另一个元素做比较：

f|返回值|优先级
---|:--:|:---:|
this > o|返回正整数 1|优先级较高(排右边)
this < o|返回负整数 -1|优先级较低(排左边)
this == o|返回 0|此时认为两个对象为同一个对象,不添加
此时 compareTo方法返回 0，则认为两个对象是同一个对象，
返回正数排前面，返回负数排后面。

需求:自定义排序，将User对象按照年龄大小排序

小结：
1> 需要实现Comparable接口才能存放在TreeSet中


```java
public class User implements Comparable<User>{

	private String name;
	private int age;

	public User(String name, int age) {
		super();
		this.name = name;
		this.age = age;
	}

	@Override
	public String toString() {
		return "User [name=" + name + ", age=" + age + "]";
	}

	@Override
	public int compareTo(User user) {
    //和集合中的元素比较
		if(this.age>user.age){   // 排后面
			return 1;
		}else if(this.age<user.age){// 排前面
			return -1;
		}else{    // 不添加
			return 0;
		}
	}


}

class Test{

  public static void main(String[] args) {

    Set<User> set=new TreeSet<User>();
		set.add(new User("后羿", 10));
		set.add(new User("百里守约", 9));
		set.add(new User("百里玄策", 14));

		System.out.println(set);
  }

}

```

#### 在TreeSet集合上加入排序规则

需求:修改String 类型数据类型按照

```java

class Test{
  public static void main(String[] args) {
    MyComparator comparator=new MyComparator();
    Set<String> set=new TreeSet(comparator);
    set.add();
  }
}

class MyComparator implements Comparator<String>{

  public int compare(String s1,String s2){
    //比较俩个字符串的长度
    if(s1.length()>s2.length()){
      return 1;
    }
    return -1;
  }

}

```

> 总结:
1. Comparator 比 Comparable 的优先级高


##### Map集合
> 注意:
* Map 集合每次存储俩个元素，一个key,一个value
* Map 没有继承Collection 没有实现Iterator,所以不能使用for-each循环

##### Map集合常用Api

```
class HashMapDemo{

  public static void main(String[] args) {

    Map<String,String> map=new HashMap();
    map.put("name","decade");
    map.put("age","18");

    System.out.println(map);
    System.out.println(map.size());
    System.out.println(map.put("age","20"));
    System.out.println(map.containKey("age"));
    System.out.println(map.containValue("decade"));
  }

}

```

---
#### Map遍历方式
* 获得map中所有的key,通过key获取value--->map.keySet()
* 获得map中所有的值,---->map.values()
* 获得map中所有的键值对EntrySet()

```
class HashMapDemo{

  public static void main(String[] args) {

    Map<String,String> map=new HashMap();
    map.put("name","decade");
    map.put("age","18");

    //获取所有的key--> 保存在set集合中
    Set<String> keySet=map.keySet();
    for(String key:keySet){
      String value=map.get(key);
      System.out.println(key+"="+value);
    }

    //将map中所有的值存放到集合中
    Collection<String> values=map.values();
    for(String v:values){
      System.out.print(v);
    }

    //-获取所有的键-值,
    Set<Map.Entry<String,String>> entries=map.entrySet();
    for(Map.Entry<String,String> entry:entries){
      String key=entry.getKey();
      String value=entry.getValue();
    }
  }

}
```
需求:统计一个字符串中的每个字符出现次数


```
class Test{

  public static void main(String[] args) {
    String str="ABCDEFABCDEABCDABCABA";
	  Map<Character,Integer> map=new HashMap<>();

	  char[] chars=str.toCharArray();
	  for(char c:chars){
		  Integer count=map.put(c, 1);
		  if(count!=null){
			  map.put(c, count+1);
		  }else{
			  map.put(c, 1);
		  }
	  }
	  System.out.println(map);
  }

}
```
---
##### Arrays 工具类
注意:
* 通过 Arrays.asList 方法得到的List 对象的长度是固定的，不能增，也不能减。

```
class Test{

  public static void main(String[] args) {
    List<Integer> list=Arrays.asList(1,2,3,4);
    System.out.println(list);
    list.remove(0); //会报错

    //重新使用新的数组包装，才可以增删
    List<Integer> newList=new ArrayList<>(list);
  }

}
```

##### Collection 工具类

```
class Test{

  public static void main(String[] args) {
    List<String> list=new ArrayList();
    list.add("阿甘正传");
    list.add("西西里的美丽传说");

    String max=Collection.max(list);
    System.out.println(max);
  }

}
```
