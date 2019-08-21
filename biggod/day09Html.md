## Html
---

```
<html>
  <!-- 注释内容:head 表示整个网页的基本配置信息 -->
  <head>
    <meta charset="utf-8">
    <title>网页标题</title>
  </head>
  <!-- body 显示网页正文 -->
  <body>
      Hello world
  </body>
</html>
```

标签属性:
1. class 规定元素的类名
2. id:元素的唯一id
3. style :ui顶元素的样式

```
a 标签
href:连接
target:打开新的窗口
<a href="www.baidu.com" target="_blank">点击打开</a>

可定义锚：
<a href="#A1"></a> 跳转到A1位置
<a name="A1"></a>
```

```
列表标签
ul : un order list (无序列表)
ol : order list (有序列表)

<ol>
    <li>后裔</li>
    <li>白起</li>
    <li>典韦</li>
</ol>

<ul>
  <li>后裔</li>
  <li>白起</li>
  <li>典韦</li>
</ul>

<dl>
  <dt></dt>
  <dd>android
      <dl>
        <dd>javase</dd>
        <dd>javaee
          <dl>
            <dd>struts2</dd>
            <dd>hibernate</dd>
            <dd>spring</dd>
          </dl>
        </dd>
      </dl>
  </dd>
  <dd>java</dd>
</dl>
```

```
<img src="‪F:\image\gril06.jpg" alt="">
```
当编程语言们加了一个微信群
易语言
![](assets/day09Html-1d9c7f88.pn g)

---
##### table 标签
style = textalign:center

<table border="0" >
  <tr>
    <th>编号</th>
    <th>姓名</th>
    <th>年龄</th>
  </tr>
  <tr>
    <td>1</td>
    <td>后裔</td>
    <td>18</td>
  </tr>
</table>

td 常见属性
colspan : 跨列
rowspan : 跨行

---
#### form 表单

type:
text:
button:
checkbox:
file:
hidden:
image:图片
password:密码
radio:单选框
reset:重置
submit:提交

<form  action="index.html" method="post">

  <!-- 隐藏域，如果是跳转到同一页面，需要判断是从哪个页面跳转过来。需要传递参数  -->
  <input type="hidden" name=id"" value="123">

  名字:<input type="text" name="username" value=""><br>
  密码:<input type="password" name="password" value=""><br>

  男:<input type="radio" name="gender" value="0" checked="true">
  女:<input type="radio" name="gender" value="1"><br>

  爱好:
  读书:<input type="checkbox" name="hobby" value="read">
  健身:<input type="checkbox" name="hobby" value="play">
  写代码:<input type="checkbox" name="hobby" value="写代码"><br>

  头像:<input type="file" name="headerUrl" value=""><br>

  地址:
  <select name="address">
    <option value="">---请选择--</option>
    <option value="gz">广州</option>
    <option value="sz">深圳</option>
  </select>
  <br>
  个人简介:<br><textarea name="info" rows="3" cols="50"></textarea><br>

  <input type="reset" value="重置">
  <input type="submit" value="提交">
</form>


##### javascript

1. js 代码放在超连接上
<a href="javascript:alert(123)">点击</a>

2. 写在head中
<script type="text/javascript">
  var age=10;
  age="decade"; // 弱类型语言
  //打印到控制台
  console.log(age);

  // 2. 定义方法,有返回值直接return ,有参数直接写参数
  function getSum(num1,num2){
    console.log(7);
    return num1+num2;
  }
  //3. 调用方法
  var sum=getSum();
  console.log(sum);
  //4. 提交表单,找到控件，给控件添加功能
  //获取到id为username
  var u=document.getElementById("username");
  console.log(u.value);

  function submitForm(){
    // 找到表单再提交
    var f=document.getElementById("f4");
    console.log(f);
    f.submit();
  }
</script>

<input type="button" name="" value="" onclick="submitForm()">
