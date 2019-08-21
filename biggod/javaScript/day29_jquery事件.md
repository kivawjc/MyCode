## jquery
---

js/json/https://wuzhihui001.iteye.com/blog/1545644

#### jquery 事件
1. ready () : 在DOM加载完成时运行代码

```js
//原生js的文件加载事件
// 整个文档加载完之后再执行函数 (会覆盖)
window.onload=function() {
  console.log(document.getElemntById("div"));
}

jquery的文档加载(执行效率高)
// 当前html 文档加载完立即回调函数
$(document).ready(function () {
  console.log($("#div"));
})

// ---------------简便代码 （可以绑定多个事件）
$(function(){
  console.log("div");
})
```


#### document.ready和onload的区别

1、加载程度不同
> document.ready：是DOM结构绘制完毕后就执行，不必等到加载完毕。意思就是DOM树加载完毕就执行，不必等到页面中图片或其他外部文件都加载完毕。
>
> onload：是页面所有元素都加载完毕，包括图片等所有元素。

2、执行次数不同

> document.ready可以写多个.ready，可以执行多次，第N次都不会被上一次覆盖。
>
> onload只能执行一次，如果有多个，那么第一次的执行会被覆盖


### 事件绑定

```js
绑定一个或多个
div.bind("click mouseover",function(){
  console.log(div.text());
})

//批量绑定事件
$(".div").bind("click",function () {
  console.log(div.text());
})


//和bind 一样
//同时对后面进来的元素绑定事件
div.on("click mouseover",function(){
  console.log(div.text());
})

//常用绑定方式
div.click(function() {
  console.log(div.text());
})
```

#### 鼠标悬停案例
```js
$("tbody tr").mouseover(function() {
  // this是事件源 (dom 对象)
  //this.style.backgroudColor="red";
  $(this).css("backgroud-color","pink")
})

$("tbody tr").mouseout(function() {
  // thi是事件源
  $(this).css("backgroud-color","")
})

//-----------链式编程--------------
$("tbody tr").mouseover(function() {
  // this是事件源 (dom 对象)
  //this.style.backgroudColor="red";
  $(this).css("backgroud-color","pink")
}).mouseout(function() {
  // thi是事件源
  $(this).css("backgroud-color","")
})


//-----------hover--------------
$("tbody tr").hover(function() {
  // this是事件源 (dom 对象)
  $(this).css("backgroud-color","pink")
},function() {
  // thi是事件源
  $(this).css("backgroud-color","")
})
```

### DOM 操作(文档处理)
prepend: 向每个匹配的元素内部的开始处插入前置内容。

```js
// append  父.append(子)
$("#div1").append($("#span"));
$("#div1").append("<b>icon man</b>");//追加标签
      //span会复制到俩个div中
$("div1").append($("#span"));

// appendTo 子.appendTo(父);
$("#span").appendTo($("#div1"));

// prepend  父.prepend(子)
$("#div1").prepend($("#span"));
// prependTo  子.prependTo(父)
$("#span").prependTo($("#div1"));

```

#### 内部插入

```js
  // 在匹配的元素之后插入元素
  //在div后面插入span
$("#div1").after($("#span"))
  // 在匹配的元素之前插入元素
$("#div1").before($("#span"))
// 内容插入到匹配元素之后  (添加到哪个元素之后)
$("#span").insertAfter($("#div2"))
// 内容插入到匹配元素之前    (添加到哪个元素之前)
$("#span").insertBefore($("#div2"))
```

#### 删除操作
* empty : 删除匹配的元素集合中所有的子节点
* remove: 移除元素后可以重新加进去,不保留事件
* detach:移除元素后可以重新加进去,保留事件

```js
 // 删除所有子节点
 $("#ul").html("");
 $("#ul").empty();
 //删除选中的节点--删除ul 中的第一个li元素
 $("#ul>li:first").remove();
 $("#ul>li:first").detach();
```

#### 复制/替换节点
clone：克隆匹配的DOM元素并且选中这些克隆的副本, 需要原本事件，传入true

```js
// 克隆btn节点,添加到div中
// 布尔值（true 或者 false）指示事件处理函数是否会被复制
var btn=$("#btn").clone(true);

// $(源).replaceWith(目标)
// 使用标签元素替换button
$("#btn").replaceWith("html文本");

// $(目标).replaceAll(源)
$('html文本').replaceAll($("#btn"));
```

### 属性操作
```js
//获取属性
$("#div").attr("ids");
$("#div").attr("xxx","ooo");//设置自定义属性值
//只能获取标准属性
$("#div").prop("ids");
// -------attr 用于获取自定义属性,prop获取标准属性
$("#div").attr("ids");
$("#div").prop("xxx");
```
css属性
```js
//添加属性样式
$(".btn").addclass("myBtn")
//删除属性样式
$(".btn").removeclass("myBtn")
// 切换元素样式
$(".btn").togglelass("myBtn")
// 判断是否有元素样式
$(".btn").hasclass("myBtn")
```

### 练习:下拉框回显

```js
//------
function ehco(){
  //选中索引为1的option
  $("#s1 option:eq(1)").prop("selected",true)
  // select 的值设置成5，选中value=5的option
  $("#s1").val(5)
}

```
### 练习:全选
```js
function checkAll(check) {
    // 点击全选/全不选
    // 将所有hobby下的元素设置成选中
    $("input[name='hobby']").prop("checked",check);
}

//反选,将原本的input check属性取反
function checkUnAll() {
    $("input[name='hobby']").prop("checked",function (index,check) {
        //获取到参数为 索引+ check的值
        // console.log(arguments);
        return !check;
    })
}

//根据勾选框决定全部勾选还是不勾
function checkChange(mainCheck) {
    $("input[name='hobby']").prop("checked",mainCheck.checked);
}
```



#### 练习:列表移动

```js
// 全部移动
function moveAll(srcSelect,distSelect){
  $("#"+srcSelect+" option").appendTo("#"+distSelect);
}

function moveSelected(srcSelect,distSelect){
  $("#"+srcSelect+" option:selected").appendTo("#"+distSelect);
}
```

#### 练习: 下拉框去重

```js
function distinct(){
  //1. 获取右边下拉框中的option 的value存到一个数组中

      var values=[];
      $.each($("s2 option"),function(index,option){
          console.log(arguments); // 观察参数
          values.push(option.value);
      })
      console.log(values);
      //2. 遍历左边下拉框中的所有的option
        //判断每个option的value是否在上面的数组中
          //存在:执行删除
          //不存在:不做操作
      $.each($("s1 option"),function(index,option){
          var value=option.value;
          if($.inArray(value,values)!=-1){//存在
            $(option).remove();
          }
      })

      // ---------数组获取的第二种方法
      var values=$.map($("#s2 option"),function(option){
        return option.value;
      })
}


//------------
$.inArray(元素,数组): 返回元素在数组中的索引,返回-1 则不在数组中
$.map(源数组,转换函数): 根据源数组计算转换成另一个数组
```



<br>
---

### json

#### json简介
* JSON: JavaScript Object Notation(JavaScript 对象表示法)

* JSON 是存储和交换文本信息的语法。类似 XML。

* JSON 比 XML 更小、更快，更易解析。

* JSON 使用 Javascript语法来描述数据对象，但是 JSON 仍然独立于语言和平台。JSON 解析器和 JSON 库支持许多不同的编程语言

#### json 语法:
* 数据在名称/值对中
* 数据由逗号分隔
* 大括号保存对象
* 中括号保存数组

```js

var obj=new Object();
obj.name="decade";
obj.age="18";
//使用json格式定义对象
var obj={"name":"decade","age":18};
console.log(obj);
//定义数组
var arr=[{"name":"decade","age":18},
         {"name":"decade","age":18},
         {"name":"decade","age":18}];
console.log(arr);

//json字符串转换成对象
var jsonString='{"name":"decade","age":18}';
// eval 会直接执行，加括号为了不报错(表示表达式)
console.log(eval("("+jsonString+")")); // eval可以解析json,不建议使用

console.log($.parseJSON(jsonString));//jquery
console.log(JSON.parse(jsonString));//原生js

```


#### json使用案例

```js
//获取账号和密码
var username=document.getElementById("username").value;
var password=document.getElementById("password").value;

var ajax=new XMLHttpRequest();
ajax.open("post","/login",true);

ajax.onreadystatechange=function(){
  if(ajax.readytState==4&& ajax.status =200){
    // 4. 接收响应数据(json数据)
    var jsonString=ajax.responseText;
    var jsonObj=$.parseJSON(jsonString);
    if(jsonObj.success){
      $("#msg").text(jsonObj.msg).css("color","green");
    }else{
      $("#msg").text(jsonObj.msg).css("color","red");;
    }
  }
}
//如果是post请求，再send方法中传递参数
// 参数格式 : 参数1=参数值1&参数2=参数值2
var param="username="+username+"&password="+password；
//设置请求头，告诉服务器数据类型和
ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
ajax.send(param);

```


后台代码
```java
@Controller
public class LoginController{

  //给浏览器响应当前的时间
  @RequestMapping("/login")
  public void getTime(HttpServletResponse resp,String username,String password){
    //指定响应数据的格式和编码格式
    resp.setContentType("application/json;charset=utf-8");
    if("root".equals(username)&&"root".equals(password)){
        //通过json字符串携带参数
        String json="{\"success\":true,\"msg\":\"登陆成功\"}";
        writer.print(json);
    }else
        String json="{\"success\":false,\"msg\":\"账号或密码出错\"}";
        writer.print(json);
    }
  }
}
```


### json库
* jackjson:springMVC 内置的一个转换json的插件，速度快
* Fastjson: 阿里出品，最快的插件

使用jackjson
1. 添加依赖
2. 测试

```java

class User{
  Long id;
  String name;
  Integer age;
  Date createTime;
}

public void testJackJson(){
  User user=new User(1L,"decade",18,new Date());
  User u2=new User(2L,"decade",18,new Date());
  User u3=new User(3L,"decade",18,new Date());

  // java 对象--> json字符串
  ObjectMapper objectMapper=new ObjectMapper();
  Stirng jsonString=objectMapper.writeValueString(user);
  System.out.println(jsonString);
  // 数组对象----> json字符串
  List<User> list=Arrays.asList(u1,u2,u3);
  String listString=objectMapper.writeValueString(list);
  System.out.println();

  // json字符串--->java对象
  User user=objectMapper.readValue(jsonString,User.class);
  System.out.println(user);

  ArrayList<User>  list01 =mapper.readValue(jsonAttStr,
               mapper.getTypeFactory().constructParametricType(ArrayList.class,User.class));
       System.out.println(list01);

}
```

### 使用fastjson
1. 导包
2. 测试fastjson

```java

User u1=new User(1L,"decade",18,new Date());
User u2=new User(2L,"decade",18,new Date());
User u3=new User(3L,"decade",18,new Date());
List<User> list=Arrays.asList(u1,u2,u3);

//-------user 对象转换成json---------
System.out.println(JSON.toJSONString(u1));
System.out.println(JSON.parseObject(JSON.toJSONString(u1),User.class));

//-------list对象转换成json------------
String jsonArray=JSON.toJSONString(list);
System.out.println(JSON.parseArray(jsonArray,User.class));
```

### Spring MVC 响应json
步骤:
1. 添加jackJson依赖(可以只加一个,默认会依赖其他的包)
2. 添加注解
  * 在类声明上使用@RestController时,类上所有的方法返回的类型都会转成json

```java
@Controller
public class UserController(){

  //执行删除之后，响应给页面结果 :(是否成功/失败的信息)
  // 将数据封装到json字符串中再响应
  @RequestMapping("/delete")
  @ResponseBody    //将返回值转成json字符串再响应
  public Object delete(){
    Map<String,Object> result=new HashMap<>();
    result.put("success",true);
    result.put("msg","删除成功");
    //将map 集合转换成json字符串再响应

    //----------使用javabean 封装
    JsonResult jsonResult=new JsonResult();
    jsonResult.setSuccess(false);
    jsonResult.setMsg("删除失败");
    return jsonResult;
  }

  @RequestMapping("/get")
  @ResponseBody
  public OBject get(){
    User u1=new User(1L,"decade",18,new Date());
    return u1.toJson();
  }

}

public class JsonResult{
  private boolean success=true;
  private String msg;
}
```

忽略字段和日期格式化
```java
class User{
  Long id;
  String name;
  Integer age;
  Date createTime;

  //可以设置忽略字段:不添加到map 中
  public Map<String,Object> toJson(){
    //按需求将数据添加到,map 集合中
    Map<String,Object> jsonObj=new HashMap<>();
    jsonObj.put("id",id);
    jsonObj.put("dname","name");
    Stirng createTimeString=new SimpleDateFormat("yyyy-MM-dd").format();
    jsonObj.put("createTime",createTimeString);
    return jsonObj;
  }
}
```
