## 校验&批量删除&统一异常处理

---

### jauery validate
参考网站: https://www.runoob.com/jquery/jquery-plugin-validate.html

#### 三层校验确认:
* js : 前端校验(脚本禁用时不生效)
* java : 后台对请求参数进行校验
* 数据库:字段not null

#### validate 俩种校验方式:
1. 调用表单validate,在表单元素中设置class属性
2. 在js 中书写validate进行校验

步骤：
1. 导入js
2. 根据表单的name进行校验，书写校验规则和提示信息

```js
//数据校验  根据表单的name进行校验
$("#editForm").validate({
  rules:{
    name:{
      required:true,
      minlength:4
    },
    password:{
      required:true,
      minlength:4
    },
    repassword{
      equalTo:"#password"
    },
    email{
      required:true,
      email:true
    },
    age{
      required:true,
      range:[18,80]
    }  
  },
  messages:{
    name:{
      required:"账号不能为空",
      minlength:"最少4位"
    },
    password:{
      required:"密码不能为空",
      minlength:"最少4位"
    },
    repassword{
      equalTo:"密码不一致"
    },
    email{
      required:"邮箱不能为空",
      email:"邮箱格式不正确"
    },
    age{
      required:"年龄不能为空",
      range:"年龄范围在18-80之间"
    }  
  }
})
```


<br>
---

### 员工批量删除
需求:
1. 如果用户没有选择需要删除的数据，给出提示
2. 如果有选择，给出确认提示
3. 点击确定，发送ajax 异步请求，执行删除
    * 获取所有选中数据id
4. 响应json格式字符串到页面
5. 页面上给出提示

操作:
1. 添加复选框
2. 全选/全不选
3. 添加批量按钮


注意:
> 数组参数传递时，不在参数添加[]
需要禁用功能
$.ajaxSettings.traditional=true;


前端js实现代码:
```js
$(function){
  // 全选/全不选
  $(".all").change(function(){
    $(".cb").prop("checked",this.checked)
  })


  $(".btn-batchDelete").click(function(){
    //获取所有选中的元素
    if($(".cb:checked").length==0){
      $.messager.alert("温馨提示","请选择要删除的数据")
      return;
    }

  //给出确认删除的提示
    $.messager.confirm("温馨提示","确认删除所选中的数据吗?",function(){
      //获取选中数据的id，将其作为参数传递
      var ids=[];
      $(".cb:checked").each(function(index,box){
        var id=$(box).data("id");
        ids.push(id);
      })
      $.get("/employee/batchDelete",{ids:ids},function(data){
          //解析响应数据
          handleMessage(data);
      })
    })
  })
}

// -----------html----------------
<input type="checkbox" class="checkBox" data-id="${entity.id}">
```

后台代码实现

```java
//批量删除
@RequestMapping("/batchDelete")
@ResponseBody
public JsonResult batchDelete(Long[]  ids){
    JsonResult result=new JsonResult();
    try{
        if(ids!=null){
            service.batchDelete(ids);
        }
    }catch (Exception e){
        e.printStackTrace();
        result.sendErrorMsg(e.getMessage());
    }
    return result;
}

service{
  public void batchDelete(Long[] ids){
      mapper.deleteByIds(ids)
  }
}

```

sql 语句：
```xml
delete from employee
where id in
<foreach collection="array" open="("
close=")" operator="," item="id">
#{id}
</foreach>

collection ： 指定迭代参数类型
            |-- list  |-- array
如果传递的是对象中的集合属性:employee->list,可以直接用属性名
open : 开始字符
close:结束字符
operator:分割符
item:迭代每一个元素 #{item}取值
```

<br>
---

### 统一异常处理

>    在Java EE项目的开发中，不管是对底层的数据库操作过程，还是业务层的处理过程，还是控制层的处理过程，都不可避免会遇到各种可预知的、不可预知的异常需要处理。

> 每个过程都单独处理异常，系统的代码耦合度高，工作量大且不好统一，维护的工作量也很大。
那么，能不能将所有类型的异常处理从各处理过程解耦出来，这样既保证了相关处理过程的功能较单一，也实现了异常信息的统一处理和维护？答案是肯定的。下面将介绍使用Spring MVC统一处理异常的解决和实现过程。

后台代码出现Spring MVC处理异常的3种方式:
1. 简单异常处理器SimpleMappingExceptionResolver
2. 使用@ExceptionHandler 注解实现异常处理
3. 实现spring 的异常处理接口HandlerExceptionResolver自定义自己的异常处理器

第一种方式,在mvc.xml中进行配置
```xml
<bean class="org.springframework.web.servlet.handler.SimpleMappingExceptionResolver">
    <!-- 定义默认的异常处理页面，当该异常类型的注册时使用 -->
    <property name="defaultErrorView" value="common/error"/>
    <!-- 定义异常处理页面用来获取异常信息的变量名，默认名为exception -->
    <property name="exceptionAttribute" value="ex"/>
    <!-- 定义需要特殊处理的异常，用类名或完全路径名作为key，异常也页名作为值 -->
    <property name="exceptionMappings">
        <value>
            org.apache.shiro.authz.UnauthorizedException=common/nopermission
            <!-- 这里还可以继续扩展不同异常类型的异常处理 -->
        </value>
    </property>
</bean>
```

<br>
---
总结:
```
jquery validate 校验:实现前端校验
  |-- 导入js,书写校验规则和提示信息

员工批量删除
1. 如果用户没有选择需要删除的数据，给出提示
2. 如果有选择，给出确认提示
3. 点击确定，发送ajax 异步请求，执行删除
    * 获取所有选中数据id
4. 响应json格式字符串到页面
5. 页面上给出提示

springmvc 的统一异常处理
后台代码出现Spring MVC处理异常的3种方式:
1. 简单异常处理器SimpleMappingExceptionResolver
2. 使用@ExceptionHandler 注解实现异常处理
3. 实现spring 的异常处理接口HandlerExceptionResolver自定义自己的异常处理器


```
