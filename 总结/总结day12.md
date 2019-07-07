### 常用类
---
#### 随机数

##### ---Math类---
Math类包含数学运算相关的方法
```java
public class MathDemo{
  public static void main(String[] args){
    //最大值和最小值
    System.out.println(Math.max(1,2));
    System.out.println(Math.max(1,2));

    // [0,1)之间的随机数
    double num=Math.random();
    System.out.println(num);

    //[0,100)之间的随机数
    int num=(int)(num*100);
    //[23,104)
    int num2=(int)(Math.random()*81+23);
  }
}
```

##### ---Random类---
```java
public class RandomDemo{
  public static void main(String[] args){
      //获取100以内的随机整数
      Random r=new Random();
      int num=r.nextInt(100);

      //获取[23,104)以内的随机数
      int num=r.nextInt(81)+23;

      //随机获取A-Z之间字母组成的验证码
      StringBuild sb=new StringBuild();
      for(int i=0;i<5;i++){
        int num=65+r.nextInt(25);
        sb.append((char)num);
      }
  }
}
```

##### ---UUID---
UUID 表示通用唯一标识符,字符串类型的真实随机数
```java
public class RandomDemo{
  public static void main(String[] args){
    String code=UUID.randomUUID().toString();

    //获取uuid的前5个字符作为验证码
    String str=code.substring(0,5);
  }
}
```
#### java.util.Date类
Date类，日期时间类，表示特定的瞬间
```java
public class TestDate{

  public static void main(String[] args){
    //拿到当前系统的时间
    Date date=new Date();
    System.out.println(d);

    //转化成本地的时间风格
    String dd=d.toLocalString();
    System.out.println(dd);

    //获取当前时间到 1970年7月1日 00：00：00的毫秒数
    long time=d.getTime();
  }

}
```
运行结果
```
Fri Mar 15 11:37:31 CST 2019
1552621051230
2019-3-15 11:37:31
```
#### java.util.SimpleDateFormat类
SimpleDateFormat类：日期格式化类
* 格式化(format):Date类型转换成String--> String format(Date date)
* 解析(parse): String 类型转换成Date --> Date parse(String sourse)

无论格式化还是解析，都需要设置日期和时间的格式

```
y  年
M  年中的月份
d  月中的天数
H  一天中的小时数
m  分钟
s  秒数
w  年中的周数
```
日期模式举例
```
yyyy-MM-ddd HH:mm:ss   2012-12-5 12:45:02
```
代码示例:
```java
public class TestFormat{
  public static void main(String[] args){
    Date d=new Date();

    String pattern="yyyy-MM-dd HH:mm:ss";
    //创建一个SimpleDateFormat
    //SimpleDateFormat sdf=new SimpleDateFormat(pattern);
    SimpleDateFormat sdf=new SimpleDateFormat();
    sdf.applyPattern(pattern);

    //格式化日期: Date--->String
    String str=sdf.format(d);
    System.out.println(str);
    //解析操作: String -->Date
    Date dd=sdf.parse("2018-12-06 11:22:00");
    System.out.println(dd);
  }
}
```
#### Calendar类
Calendar是一个抽象类,getInstance()底部用子类去实现

```java
public class CalendarDemo{

  public statci void main(){
    //创建Calendar对象
    Calendar c=Calendar.getInstance();

    //int get(int feild)
    int year=c.get(Calendar.YEAR);
    int month=c.get(Calendar.MONTH+1);
    int date=c.get(Calendar.DATE);
    int hour=c.get(Calendar.HOUR_OF_DAY);
    int minute=c.get(Calendar.MINUTE);
    int second=c.get(Calendar.SECOND);
    System.out.println(year);
    System.out.println(month);
    System.out.println(date);
    System.out.println(hour);
    System.out.println(minute);
    System.out.println(second);

    c.add(Calendar.YEAR,100);//年份加一百
  }

}
```

需求:查询某个时间最近一周的信息

```java
public class TestWeekTime{

  public statci void main(){
    String inputTime="2018-05-18";//输入时间

    SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd");
    Date d=sdf.parse(inputTime);

    Calendar c=Calendar.getInstance();
    c.setTime(d);

    //设置当天的最后一秒钟
    c.set(Calendar.HOUR_OF_DAY,23);
    c.set(Calendar.MINUTE,59);
    c.set(Calendar.SECOND,59);

    //获取结束时间
    Date endDate=c.getTime();

    //开始时间:7天以前，秒数加1，天数减7
    c.add(Calendar.SECOND,1);
    c.add(Calendar.DATE,-7);
    Date startDate=c.getTime();
  }

}
```

---
#### 正则表达式
* 正则表达式，简写成regex
* 正则表达式用于判断一个字符是否符合指定的规则
