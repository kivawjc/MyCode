##### Xml 讲解
---
##### 为什么使用配置文件？
* 解决硬编码，将写死的数据配置到配置文件中，修改数据时，不需要修改源码

#### 常用配置文件
1. properties : 保存简单的key-value形式的数据
2. xml : 可以保存复杂的数据，结构清晰

---
#### xml 概述
* xml(extensible markup language) 是一种可扩展(自定义)的标记语言,xml 是W3c组织发布的
* 设计的宗旨是传输数据，一种通用的数据格式
* 没有预定义，属于自定义标签

#### xml 语法

xml 示例
```
<?xml version="1.0" encoding="utf-8"?>
<bookstore>
    <book id="1">
        <name>老人与海</name>
        <price>100</price>
    </book>
    <book id="1">
        <name>老人与海</name>
        <price>100</price>
    </book>
</bookstore>
```

```

<?xml version="1.0" encoding="utf-8"?>
1. 第一行固定写法:文档(xml)声明
  * version:版本
  * encoding:编码,xml中存在俩个编码,要求一致
      |---encoding:文档内容的编码格式
      |---文件的编码格式
2. <>标签/元素
  * 根标签直接属于xml文档，有且仅有一个
  * 多个属于xml文档会报错
3. 标签有开始标签和结束标签
  * 开始和结束可以有子标签
  * 如果一个元素没有子标签，可以使用单标签
4. 标签的属性,用来描述该标签
   <book 属性名=属性值/>
5. 在xml中，严格区分大小写
6. 在xml文档中，允许标签嵌套，但不允许标签交叉嵌套
```

#### xml 文档结构分析
在面向对象的角度分析
1. 加载xml到内存中，使用一个对象描述文档
    Document
2. 每一个xml都有标签,使用一个对象描述
    Element
3. 每一个标签都有属性,使用一个对象描述
    Attribute
4. 在xml中的文本使用对象描述
    Text

```
Document{
  Element{
    Attribute
    Text
  }
}
```

需求1: 获取第二本书的名字
1. 获取 Document 对象
2. 获取根Element
3. 获取第二个book的Element
4. 获取book 的name Element
5. 获取name Element 的Text

---
##### DOM 解析
DOM : (Document Object Model) 文档对象模型
* 特点: 在加载XML文档时，一次性把所有的信息加载到内存中，使用Document对象描述
* 缺点: 当XML数据量大时，一次性加载到内存中，容易导致内存溢出
* 注意：
    * 导包时,导入org.w3c.dom
    * xml中一切都是节点(多个类都extends Node接口)

##### 获取Document对象

```
步骤:
1. 获取factory对象
DocumentFactory factory=DocumentFactory.newInstance();
2. 获取builder对象
DocumentBuilder builder=factory.newDocumentBuilder();
3. 获取Document对象
    |---根据已存在的数据源解析
      Document doc=builder.parse(File f);
    |---使用java代码生成一个新的空的Document对象
      Document doc=builder.newDocument();
```

需求:获取Document对象

```
public class DocumentTest{

  public void testGetDocument() {
    File file=new File("xxxxx/book.xml");
    //获取factory对象
    DocumentFactory factory=DocumentFactory.newInstance();
    //获取builder对象
    DocumentBuilder builder=factory.newDocumentBuilder();
    //获取Document对象-->使用parse方法得到的对象是Document对象的实现类
    Document doc=builder.parse(file);
  }

}
```

常用Api：(按F4查看类的继承树)
```
Document:
Element getDocumentElement() 访问文档的根节点
Element createElement(String tagName)  创建指定类型的元素。

Element:
NodeList getElementsByTagName(String name) 根据标签名获取元素列表
String getAttribute(String name) 获取属性值
void setAttribute(String name,String value) :设置属性

Node对象:
String getTextContent():获取元素文本数据
Node removeChild(Node oldChild):传入移除节点,返回移除的节点,父节点调用
Node appendChild(Node newChild):父标签添加子标签

NodeList 对象:
int getLength(): 获取数量

Transformer : 转换器，用于同步Document内存对象到数据文件

```

#### -------查询操作--------
需求:获取第二个book的name标签的值

book.xml
```
<?xml version="1.0" encoding="utf-8"?>
<bookstore>
    <book id="1">
        <name>老人与海</name>
        <price>100</price>
    </book>
    <book id="2">
        <name>白夜行</name>
        <price>100</price>
    </book>
</bookstore>
```
###### 示例代码
```
public class DomTest{

  File file=new File("xxxxx/book.xml");

  public void testGetBook(){
    //获取Document对象
    Document doc=DocumentFactory.newInstance()
                  .newDocumentBuilder()
                  .parse(file);
    //获取根节点
    Element rootEle=doc.getDocumentElement();
    //获取标签列表
    NodeList nodeList=rootEle.getElementsByTagName("book");
    //book2是一个标签，需要强转
    Element book2=(Element)nodeList.item(1);
    //获取name节点
    Element nameEle=book2.getElementsByTagName("name").item(0);
    String text=nameEle.getTextContent();
  }

}
```

#### -----修改操作-------
需求:修改book的price标签值

步骤:
1. 获取元素price
2. 设置值
3. 同步到磁盘文件(将xml加载到内存中,修改document对象，只修改了内存数据,需要进行数据同步保存)


```
File file=new File("xxxxx/book.xml");

public void testGetBook(){
  //获取Document对象
  Document doc=DocumentFactory.newInstance()
                .newDocumentBuilder()
                .parse(file);
  //获取根节点
  Element rootEle=doc.getDocumentElement();
  //获取book标签
  Element book=(Element)rootEle.getElementsByTagName("book").item(0);

  //获取name节点
  Element nameEle=book.getElementsByTagName("price").item(0);
  //设置值
  nameEle.setTextContent("80");

  TransformerFactory factory=TransformerFactory.newInstance();
  Transformer transformer=factory.newTransformer();

  //源是内存的document对象
  Source xmlSource=new DOMSourse(doc);
  //目标是磁盘文件
  Result outputTargert=new StreamResult(file);
  //将内存对象保存到本地文件
  transformer.transform(xmlSource,outputTargert);

}
```

#### --------删除操作----------
需求:删除指定元素

```
File file=new File("xxxxx/book.xml");

public void testDeleteBook(){
  //获取Document对象
  Document doc=DocumentFactory.newInstance()
                .newDocumentBuilder()
                .parse(file);
  //获取根节点
  Element rootEle=doc.getDocumentElement();
  //获取book标签
  Element book=(Element)rootEle.getElementsByTagName("book").item(0);

  //------------------------
  //父节点删除子节点
  //rootEle.removeChild(book);
  //子节点获取父节点，再使用父节点删除子节点
  book.getParentNode().removeChild(book);
  //------------------------

  TransformerFactory factory=TransformerFactory.newInstance();
  Transformer transformer=factory.newTransformer();
  //源是内存的document对象
  Source xmlSource=new DOMSourse(doc);
  //目标是磁盘文件
  Result outputTargert=new StreamResult(file);
  //将内存对象保存到本地文件
  transformer.transform(xmlSource,outputTargert);

}
```
#### ---------添加操作---------
添加: 添加一个节点

```
File file=new File("xxxxx/book.xml");

public void testDeleteBook(){
  //获取Document对象
  Document doc=DocumentFactory.newInstance()
                .newDocumentBuilder()
                .parse(file);
  //获取根节点
  Element rootEle=doc.getDocumentElement();

  Element bookEle=rootEle.createElement("book");

  Element nameEle=rootEle.createElement("name");
  Element priceEle=rootEle.createElement("price");

  nameEle.setTextContent("解忧杂货店");
  priceEle.setTextContent("80");

  //--------设置层级关系----------
  rootEle.appendChild(bookEle);

  bookEle.appendChild(nameEle);
  bookEle.appendChild(priceEle);
  //---------------------------

  TransformerFactory factory=TransformerFactory.newInstance();
  Transformer transformer=factory.newTransformer();
  //源是内存的document对象
  Source xmlSource=new DOMSourse(doc);
  //目标是磁盘文件
  Result outputTargert=new StreamResult(file);
  //将内存对象保存到本地文件
  transformer.transform(xmlSource,outputTargert);

}
```

##### 创建新的xml文件
需求:使用java创建一个xml文件
步骤:
1. 创建一个Document对象
2. 创建根节点
3. 创建子节点
4. 设置数据设置层级关系
5. 同步到本地文件

```
File file=new File("xxxxx/book.xml");

public void testDeleteBook(){
  //获取Document对象
  Document doc=DocumentFactory.newInstance()
                .newDocumentBuilder()
                .parse(file);
  //获取根节点
  Element rootEle=doc.getDocumentElement();
  //获取book标签
  Element book=(Element)rootEle.getElementsByTagName("book").item(0);

  //------------------------
  //父节点删除子节点
  //rootEle.removeChild(book);
  //子节点获取父节点，再使用父节点删除子节点
  book.getParentNode().removeChild(book);
  //------------------------

  TransformerFactory factory=TransformerFactory.newInstance();
  Transformer transformer=factory.newTransformer();
  //源是内存的document对象
  Source xmlSource=new DOMSourse(doc);
  //目标是磁盘文件
  Result outputTargert=new StreamResult(file);
  //将内存对象保存到本地文件
  transformer.transform(xmlSource,outputTargert);

}
```
#### ---------添加操作---------
添加: 添加一个节点

```
File file=new File("xxxxx/book2.xml");

public void testDeleteBook(){
  //获取Document对象
  Document doc=DocumentFactory.newInstance()
                .newDocumentBuilder()
                .newDocument();

  //创建根节点
  Element rootEle=doc.createElement("bookstore");
  doc.appendChild(rootEle);

  //创建子节点
  Element bookEle=rootEle.createElement("book");

  Element nameEle=rootEle.createElement("name");
  Element priceEle=rootEle.createElement("price");

  nameEle.setTextContent("解忧杂货店");
  priceEle.setTextContent("80");

  //--------设置层级关系----------
  rootEle.appendChild(bookEle);

  bookEle.appendChild(nameEle);
  bookEle.appendChild(priceEle);
  //---------------------------

  TransformerFactory factory=TransformerFactory.newInstance();
  Transformer transformer=factory.newTransformer();
  //源是内存的document对象
  Source xmlSource=new DOMSourse(doc);
  //目标是磁盘文件
  Result outputTargert=new StreamResult(file);
  //将内存对象保存到本地文件
  transformer.transform(xmlSource,outputTargert);

}
```
