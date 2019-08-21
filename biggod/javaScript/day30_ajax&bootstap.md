## jquery.ajax & bootstrap

---

### jquery 中 ajax 相关操作
1. jquery 的ajax 方法参数描述

| 参数 | 描述    |
| :------------- | :------------- |
| type       |  请求方式 ("POST" 或 "GET")， 默认为 "GET"      |
| url       |  (默认: 当前页地址) 发送请求的地址。  |
| data  |  发送到服务器的数据。将自动转换为请求字符串格式,必须为 Key/Value 格式 |
| success       |  请求成功后的回调函数  |


代码示例:
```js
function fun1() {
  // 括号内使用json对象
  $.ajax({
    type:"GET",  //请求方式
    url:"#",    // 请求资源
    data:"name=decade&&age=18",
    success:function(msg){// readyState==4 && status ==200 时执行
      console.log(msg);
    }
  })


  $.get("#",{name:decade,age=18},function(msg){
      console.log(msg);
  },"json"); // 返回的文本应该时json
}

----------html----------
<button onclick="fun1"></buttion>
```


### get 请求检查账号的唯一

```js
$(function（）{
  $("input[name=username]").change(function(){
        $.get("/xxx",{name:this.values},function(result){
            $("#msg").css("color",result.success?"red":"green")
            .html(result.msg);
        },"json")
  })
})

-------------html---------------
账号:<input name="username" /><br>
<span id="msg"></span>
```

```java
@Controller
ResisetController{
  @ResponseBody
  @RequestMapping("/checkuserName")
  JsonResult checkUsername(String username){
    if("decade".equals(username)){
      return new JsonResult(true,"账号已存在");
    }else{
      return new JsonResult(true,"账号名可用");
    }
  }
}
```


### 二级联动
1. 查询的时机
    * |-- 省:页面加载时,立即发送请求获取省份数据
    * |-- 市 :省的数据发生改变时,发送请求获取城市列表数据
2. 数据回显
    * |-- 将获取到的省份追加到province下拉框中

```js
$(function(){

    // 请求获取省份数据
    $.get("/getProvonce",function(province){
      //接收后台响应回来的省份的数据
        console.log(province);
      //将数据设置ida ooption元素中

      province.foreach(function(p){
        //1. 创建option元素
        var option=$("<option>");
        option.attr("value",p.id)
        option.text(p.name);
        //2. 将option 追加到select
        $("#select").append(option);
      });

    });


    //province 值改变时
    $("#province").change(function(){
        //先清空city的option 列表
        $("#city").html("<option>---请选择---</option>");

        $.get("/getCity",{provinceId:this.value},function(city){

          console.log(city);

          city.foreach(function(c){
            //1. 创建option元素
            var option=$("<option>");
            option.attr("value",c.id)
            option.text(c.name);
            //2. 将option 追加到select
            $("#select").append(option);
          });

        });

    })
})
```

```html
省:<select id="province"></select>
市:<select id="city"></select>
```


```java
@Controller
CasecadeController{
  @ResponseBody
  @RequestMapping("/getCity")
  Object getCity(Long pid){
    //根据省份的id获取城市列表数据
    return City.getCityByProvinceId();
  }
}
```
