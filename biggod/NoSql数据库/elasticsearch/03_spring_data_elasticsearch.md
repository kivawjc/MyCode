## Spring Data Elasticsearch

1. 导入依赖

```xml
<!--SpringBoot整合Spring Data Elasticsearch的依赖-->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-data-elasticsearch</artifactId>
</dependency>
```


2. 创建一个domian 类 User

```java

Document 注解:配置映射器到elestaticsearch 服务器的信息
    索引 / 类型 /映射

@Data
@Document(indexName="rbac",type="user")  : 启动应用时没有索引，可以自动生成
public class User(){
  @Id   //时文档的_id
  private Long id;
  // 指定分词器
  @Field(type=Field.text,analyzer="ik_max_word",search_analyzer="ik_max_word")
  private String name;
  private Long deptId;
}
```
配置连接ES集群的名称

```properties
# 配置集群名称，名称写错会连不上服务器，默认elasticsearch
spring.data.elasticsearch.cluster-name=elasticsearch
# 配置集群节点
spring.data.elasticsearch.cluster-nodes=localhost:2300
```

### 组件介绍
```java
ElasticsearchTemplate：框架封装的用于便捷操作Elasticsearch的模板类
ElasticsearchRepository：框架封装的用于便捷完成CRUD的接口
NativeSearchQueryBuilder：用于生成查询条件的构建器，需要去封装各种查询条件

QueryBuilder：该接口表示一个查询条件，其对象可以通过QueryBuilders工具类中的方法快速生成各种条件
boolQuery()：生成bool条件，相当于 "bool": { }
matchQuery()：生成match条件，相当于 "match": { }
rangeQuery()：生成range条件，相当于 "range": { }

AbstractAggregationBuilder：用于生成分组查询的构建器，其对象通过AggregationBuilders工具类生成
Pageable：表示分页参数，对象通过PageRequest.of(页数, 容量)获取
SortBuilder：排序构建器，对象通过SortBuilders.fieldSort(字段).order(规则)获取
```

### ElasticsearchRepository
* 该接口是框架封装的用于操作Elastsearch的高级接口
* 自定义接口去继承该接口就能直接对Elasticsearch进行CRUD操作

```java
-----------创建ElasticsearchRepository--------
// 由框架创建动态代理对象
/**
* 泛型1：domain的类型
  泛型2：@Id的类型
  该接口直接该给Spring，底层会使用JDK代理的方式创建对象，交给容器管理
*/
@Repository
interface UserSearch extends ElasticsearchRepository<User,Long>{
  // 根据名字查询
  List<User> findUserByName(String name);
}
```

注意: 一般情况下，ElasticsearchTemplate和ElasticsearchRepository是分工合作的，ElasticsearchRepository用于完成CRUD操作，如果遇到底层操作和聚合查询则要使用ElasticsearchTemplate

```java
@RunWith(SpringRunner.class)
@SpringBootTest
public class ElasticsearchApplicationTest{
    //注入 spring data 提供的俩个核心操作对象
    @Autowired
    private ElasticsearchTemplate elasticsearchTemplate;

    @Autowired
    private UserSearch userSearch; //做增删改查

      // 当执行save 方法时，如果id值在索引中存在了，就执行覆盖(更新)，不存在执行新增操作
    @Test
    public void saveOrUpdate(){
      // id 不能指定为null,否则会把null当成id
      // 因为使用时，会直接用mysql的数据进行导入，所以id需要指定
      User u=new User(1L,"骑士decade",18,1L);
      userSearch.save(u);
      System.out.print(u);
    }

    @Test
    public void testDelete(){
        // 删除id指定了类型，存入的数据要相同
        userSearch.deleteById(1L);
    }

    @Test
    public void list(){
      Iterable<User> users=userSearch.findAll();
       users.foreach(System.err::pringtln);
    }

    @Test
    public void get(){
      // Optional : 避免空指针的容器
        Optional<User> user=userSearch.findById(null);
        user.ifPresent(System.out::print);
    }


    public void getByName(){
      List<User> users=userSearch.findUserByName("decade");
       users.foreach(System.err::pringtln);
    }

```
#### 高级查询
```java

    //分页查询文档显示第二页，每页显示3个，按照id升序
    @Test
    public void pageOrder(){
        //查询对象构建器
        NativeSearchQueryBuild builder=new NativeSearchQueryBuild();
        //设置查询参数
        builder.withSort(SortBuilders.fieldSort("id")
        .order(SortOrder.DESC))
        .withPageable(PageRequest.of(2,3)); // 直接写页数，不需要计算
        Page<User> page=userSearch.search(builder.build());

        System.out.print("总文档数:"+page.getTotalElements());
        System.out.print("总页数:"+page.getTotalPages());
        List<User> list=page.getContent();
        System.out.println(list);
    }

```


* 查询所有name含有zhang的文档

```js
 {
     "query":{
      "match":{"name":"zhang"}
      }
  }
```
```java
@Test
public void queryByName(){
    //查询对象构建器
    NativeSearchQueryBuild builder=new NativeSearchQueryBuild();
    builder.withQuery(QueryBuilds.matchQuery("name","zhang"));

    Page<User> page=userSearch.search(builder.build());
    page.forEach(System.out::print);
}

```

* 查询所有name含有zhang 或者age=33的文档

```js
{
  "query":{
      "bool":{
       "should":[
            {"match":{"name"="zhang"}}
       ]
    }
  }
}
```

```java
public void query1(){
  //查询对象构建器
  NativeSearchQueryBuild builder=new NativeSearchQueryBuild();
  //拼接查询条件
  builder.withQuery(QueryBuilds.boolQuery()
      .should(QueryBuilds.matchQuery("name","decade"))
      .should(QueryBuilds.matchQuery("age","33"))
  );
  //获取查询结果
  Page<User> page=userSearch.search(builder.build());
  page.forEach(System.out::print);
}


```

* 查询所有name含有zhang 或者age=33的文档

```js
{
  "query":{
    "bool":{
      "must":[
        {"match":{"name":"wang"}}
      ],
      "filter":[
        {"range":{"age":{"gte":30,"lte":32}}}
      ]
    }
  }
}
```

```java

public void query2(){
  //查询对象构建器
  NativeSearchQueryBuild builder=new NativeSearchQueryBuild();
  builder.withQuery(
    QueryBuilds.boolQuery()
      .must(QueryBuilds.matchQuery("name","decade"))
      .filter(QueryBuilds.rangeQuery("age").gte(30).lte(32))
  );

  Page<User> page=userSearch.search(builder.build());
  page.forEach(System.out::print);
}

```

* 按照部门分组，统计文档数量

```js
{
  aggs:{
      groupByDept:{
        terms:{field:"deptId"}
      }
  }
}
---------------查询结果-------------
"aggregations" : {
    "groupByDept" : {
      "doc_count_error_upper_bound" : 0,
      "sum_other_doc_count" : 0,
      "buckets" : [
        {
          "key" : 1,
          "doc_count" : 4
        },
        {
          "key" : 2,
          "doc_count" : 3
        },
        {
          "key" : 3,
          "doc_count" : 3
        }
      ]
    }
  }

```

```java
@Test
public void query5(){
  // 创建查询条件
  NativeSearchQueryBuilder builder=new NativeSearchQueryBuilder();
  builder.withIndices("rbac").withTypes("user"); // 设置索引和类型
  // 添加分组条件
  builder.addAggregation(AggregationBuilders.terms("groupByDept").field("deptId"));

  //获取到aggregations
  Aggregations aggregations = elasticsearchTemplate.query(builder.build(), new ResultsExtractor<Aggregations>() {
      @Override
      public Aggregations extract(SearchResponse searchResponse) {
          return searchResponse.getAggregations();
      }
  });

  //获取到aggregations
  Map<String, Aggregation> asMap = aggregations.getAsMap();
  System.err.println(asMap);
  //获取到 groupByDept
  LongTerms groupByDept = (LongTerms) asMap.get("groupByDept");
  //获取 buckets
  List<LongTerms.Bucket> buckets = groupByDept.getBuckets();
  for (LongTerms.Bucket bucket : buckets) {
      Number keyAsNumber = bucket.getKeyAsNumber();// 获取分组的key
      long docCount = bucket.getDocCount(); // 获取分组的数量
      System.err.println(String.format("key:%d---docCount:%d",keyAsNumber,docCount));
  }
}

```

* 按照部门编号分组，统计各部门的年龄状态

```js
{
  aggs:{
      groupByDept:{
        terms:{field:"deptId"},
        aggs:{
          statAge:{
            stats:{
              field:age
            }
          }
        }
      }
  }
}

--------------执行结果---------------
"aggregations" : {
    "groupByDept" : {
      "buckets" : [
        {
          "key" : 1,
          "doc_count" : 4,
          "statsByAge" : {
            "count" : 4,
            "min" : 12.0,
            "max" : 33.0,
            "avg" : 21.25,
            "sum" : 85.0
          }
        }
      ]
    }
  }

```

```java
public void query4(){
  NativeSearchQueryBuilder builder=new NativeSearchQueryBuilder();
    builder.withIndices("rbac").withTypes("user"); // 设置索引和类型
    //拼接分组条件
    builder.addAggregation(
            AggregationBuilders.terms("groupByDept").field("deptId")   // 设置分组字段
            .subAggregation(AggregationBuilders.stats("statsByAge").field("age"))   // 设置统计的年龄字段
    );
    Aggregations aggregations = elasticsearchTemplate.query(builder.build(), searchResponse -> searchResponse.getAggregations());
    //获取 groupByDept
    Map<String, Aggregation> asMap = aggregations.getAsMap();
//        System.err.println(asMap);

    // 获取 buckets
    LongTerms groupByDept = (LongTerms) asMap.get("groupByDept");
    List<LongTerms.Bucket> buckets = groupByDept.getBuckets();
    for (LongTerms.Bucket bucket : buckets) {

        // 获取 {statsByAge={"statsByAge":{"count":4,"min":12.0,"max":33.0,"avg":21.25,"sum":85.0}}}
        InternalAggregations internalAggregations = (InternalAggregations) bucket.getAggregations();
        Map<String, Aggregation> bucketMap = internalAggregations.getAsMap();

        // 根据 statsByAge 获取
        InternalStats statsByAge = (InternalStats) bucketMap.get("statsByAge");
        long count = statsByAge.getCount();
        double min = statsByAge.getMin();
        double max = statsByAge.getMax();
        double avg = statsByAge.getAvg();
        double sum = statsByAge.getSum();
        // %d 整数  %f 小数  %s 字符串
        System.err.println(String.format("count:%d,min=%f,max=%f,avg=%f,sum=%f",count,min,max,avg,sum));
    }
}
```
