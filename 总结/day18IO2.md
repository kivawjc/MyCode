## IO流的文件复制

---

##### 文件的复制拷贝
>总结
* 文件的复制拷贝主要使用字节流进行操作，使用字符流只能操作文本文件

```
class CopyDemo{

  /**
  * 使用字符流只能复制文本文件
  */
  public void test01(){
    Reader r=new FileReader("a.txt");
    Writer w=new FileWriter("b.txt");
    char[] arr=new char[1024];
    int len;
    while((len=r.read(arr))!=-1){
      w.write(arr,0,len);
    }
    r.close();
    w.close();
  }


  /**
  * 使用文件字节流读取文件
  */
  @Test
  public void test02(){

      InputStream in=new FileInputStream("gril02.jpg");
      OutputStream out=new FileOutputStream("gril02副本.jpg");

      //复制文件操作
      byte[] bytes=new byte[1024];
      int len;
      while((len=in.read(bytes))!=-1){
        out.write(bytes, 0, len);
      }

      in.close();
      out.close();
    }
  }

}
```

#### 异常处理
```
public void test02(){
		InputStream in=null;
		OutputStream out=null;

		try {
			in=new FileInputStream("gril02.jpg");
			out=new FileOutputStream("gril02副本.jpg");

	    // 。。。流处理
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			try {
				if(in!=null){
					in.close();
				}
			} catch (IOException e) {
				e.printStackTrace();
			}
			try {
				if(out!=null){
					out.close();
				}
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
	}
```

新格式关流(1.7 ApI)

```
try(流对象的创建){
  流的操作
}catch(异常类){
  处理方式
}// 这里自动关闭流
```

```
public void test03(){
		try(
			Reader r=new FileReader("");//流对象创建
			Writer w=new FileWriter("");
		){
			r.read(); //流操作
			w.write("");
		}catch (Exception e) {
		}
	}
```

#### 缓冲流
包装流:对基本流进行包装增强

```
BufferWriter bw=new BufferWriter(new FileWriter(""));
```
 使用缓冲流复制文件
```
  @Test
	public void test04() throws Exception{
		System.out.println("开始复制");
		BufferedInputStream bis=new BufferedInputStream(new FileInputStream("gril02副本.jpg"));
		BufferedOutputStream bos=new BufferedOutputStream(new FileOutputStream("gril04.jpg"));

		byte[] bytes=new byte[1024];
		int len=0;
		while((len=bis.read(bytes))!=-1){
			bos.write(bytes);
		}
		System.out.println("复制成功");

		bis.close();
		bos.close();
	}
```

```
  @Test
	public void test05() throws Exception{
		BufferedReader br=new BufferedReader(new FileReader("书籍"));
		String str=null;
		while((str=br.readLine())!=null){
			System.out.println(str);
			Thread.sleep(500);
		}
		br.close();
	}
```
##### 序列化
* 序列化： 将java对象持久化保存到本地
* 反序列：将本地
```
ObjectoutputStream 通过writeObject()实现序列化
ObjectInputStream 通过readObject()实现反序列化
注意:
做序列化的类需要实现Serializable
```

```
public class User implements Serializable{
  private String name;
  private int age;
}

public class Demo{
  public static void main(String[] args) {
    //1.创建对象
    User u1=new User("decade",12);
    //2.对象序列化
    ObjectOutputStream oos=new ObjectOutputStream(new FileOutputStream("user.txt"));
    oos.writeObject(u1);

    //反序列化
    ObjectInputStream ois=new ObjectInputStream(new FileInputStream("user.txt"));
    User user=ois.readObject();

    System.out.print(user.toString());
  }
}
```

#### 打印流
```
class PrintDemo{
  public static void main(String[] args) {
    PrintStream ps=new PrintStream(new FileOutputStream("a.txt"));

    ps.println("decade");
    //不需要关流
  }
}
```

#### Scanner接受键盘输入

```
class ScannerDemo{

  public static void main(String[] args) {
    Scanner sc=new Scanner(System.in);
    int a=sc.nextInt();
    int b=sc.nextInt();

    System.out.println(a>b?a:b);
  }


}
```
##### 运行结果
```
4
5
max=5
```
#### 猜数字
```
public static void main(String[] args) {
		Random r=new Random();
		int num=r.nextInt(100);

		System.out.println("请输入一个数字:");
		Scanner scan=new Scanner(System.in);

		while(true){
			int scanNum=scan.nextInt();

			if(scanNum==num){
				System.out.println("猜对了,游戏结束");
				break;
			}else if(scanNum>num){
				System.out.println("猜大了");
				System.out.println("-------重新输入--------");
			}else if(scanNum<num){
				System.out.println("猜小了");
			}
		}

}

```
##### 运行结果
```
请输入一个数字:
50
猜小了
-------重新输入--------
75
猜小了
-------重新输入--------
85
猜小了
-------重新输入--------
90
猜大了
-------重新输入--------
87
猜小了
-------重新输入--------
89
猜对了,游戏结束
```

#### File 类
File 类只能设置和获取文件的信息，不能设置和修改文件的内容

方法名|功能
--|:--:|
String getName()|获取文件名称
getPath()|获取文件路径
String getAbsolutePath()| 获取绝对路径,从盘符开始记录
File getParentFile()|获取上级目录文件
boolean exists()|判断文件是否存在
boolean isFile()|是否是文件
boolean isDirectory()|判断是否是目录
boolean delete()|删除文件,只能删除文件和空目录
boolean mkdirs()|创建当前目录，如果上级目录不存在一起创建
File[] listFiles()|列出所有文件对象
```
class FileDemo{

  public static void main(String[] args) {
      //1.创建File对象
      File file=new File(文件路径);

      System.out.print(file.getName());
      System.out.print(file.getPath());
      System.out.print(file.getAbsolutePath());
  }

}
```
 ##### 查找文件
 需求:查找目录下的所有文件
 ```
 public void findFile(File dir){
		File[] files=dir.listFiles();
		if(files==null){//如果由访问权限会报空
			return;
		}
		for(File f:files){
			if(f.isDirectory()){ //如果是目录，进行递归
				findFile(f);
			}else{
				String name=f.getName();
				if(name.endsWith(".java")){
					System.out.println(f.getAbsolutePath());
				}
			}
		}
	}
 ```
