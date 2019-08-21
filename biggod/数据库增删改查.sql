 
-- 创建表
CREATE TABLE t_user(
id BIGINT PRIMARY KEY AUTO_INCREMENT,
NAME VARCHAR(20),
age INT(10)
);

-- 删除表
DROP TABLE t_user;

-- 查看表结构
DESC t_user;

-- 查看创建表的语句
SHOW CREATE TABLE t_user;

-- 插入记录
INSERT INTO t_user(id,NAME,age) VALUES(NULL,'decade',12);
INSERT INTO t_user VALUES(NULL,'kiva',18);

-- 删除记录
-- 1. 不带条件
DELETE FROM t_user;
-- 2. 带条件
DELETE FROM t_user WHERE id=1;

-- 修改记录
-- 1. 不带条件 : 修改整张表的数据
UPDATE t_user SET NAME='decade';
-- 2. 带条件 : 修改指定的记录
UPDATE t_user SET NAME='后裔' WHERE id=1;

 -- 1. 查询所有商品信息
SELECT * FROM product;

-- 2. 查询所有商品的id,productName,salePrice
SELECT id,productName,salePrice FROM product;

-- 3. 查询商品的分类编号(消除结果中重复的数据)
SELECT DISTINCT id FROM product;

-- 4. 查询所有货品的id,名称和批发价(批发价=卖价*折扣)
SELECT id,productName,costPrice*cutoff FROM product;

-- 5. 查询所有货品的id,名称和各进50个的成本价(成本=costprice)
SELECT id,productName,costPrice*50 FROM product;

-- 6. 查询所有货品的id,名称和各进50个并且每个运费1元的成本
SELECT id,productName,(costPrice+1)*50 FROM product;

-- 7. 查询 xx的售价是xx
SELECT CONCAT(productName,'的售价是￥',costPrice) FROM product;


-- 2> 比较运算符

-- 需求: 查询货品零售价为119的所有货品信息.
SELECT * FROM product WHERE salePrice=119;

-- 需求: 查询货品名为罗技G9X的所有货品信息.  BINARY区分大小写
SELECT * FROM product WHERE BINARY productName='罗技G9X';

-- 需求: 查询货品名 不为 罗技G9X的所有货品信息.
SELECT * FROM product WHERE productName!='罗技G9X'

-- 需求: 查询分类编号不等于2的货品信息
SELECT * FROM product WHERE dir_id!=2

-- 需求: 查询货品名称,零售价小于等于200的货品
SELECT productName,salePrice FROM product WHERE salePrice<=200;

-- 需求: 查询id，货品名称，批发价大于350的货品
SELECT id,productName,costPrice FROM product WHERE costPrice>350;


-- 3> 逻辑运算符

-- 需求: 选择id，货品名称，零售价在300-400之间的货品
SELECT id,productName,salePrice FROM product WHERE salePrice>300 AND salePrice<400

-- 需求: 选择id，货品名称，分类编号为2或4的所有货品
SELECT id,productName,dir_id FROM product WHERE dir_id=2 OR dir_id=4

-- 需求: 选择id，货品名称，分类编号不为2的所有商品
SELECT id,productName,dir_id FROM product WHERE NOT dir_id=2;

-- 需求: 选择id，货品名称，分类编号的货品零售价大于等于250或者成本大于等于200
SELECT id,productName,dir_id FROM product WHERE salePrice>=250 OR costPrice>=200;


-- 4> 范围查询
-- 需求: 选择id，货品名称，零售价在300-400之间的货品
SELECT id,productName,salePrice FROM product WHERE salePrice BETWEEN 300 AND 400;

-- 需求: 选择id，货品名称，零售价不在300-400之间的货品
SELECT id,productName,salePrice FROM product WHERE salePrice NOT BETWEEN 300 AND 400;

-- 5> 集合查询
-- 需求:选择id，货品名称，分类编号为2或4的所有货品
SELECT id,productName,dir_id FROM product WHERE dir_id IN (2,4);

-- 需求:选择id，货品名称，分类编号不为2或4的所有货品
SELECT id,productName,dir_id FROM product WHERE dir_id NOT IN (2,4);

-- 6> 空值查询
-- 需求:查询商品分类编号为NULL的所有商品信息
SELECT * FROM product WHERE dir_id IS NULL 

-- 需求:查询商品分类编号不为NULL的所有商品信息
SELECT * FROM product WHERE dir_id IS NOT NULL;

-- 设置某一列的数据为null,    列名=null
UPDATE product SET dir_id=NULL WHERE id=20;


-- 7> 模糊查询
-- 需求: 查询货品名称带有 'M' 的所有信息
SELECT * FROM product WHERE productName LIKE '%M%';

-- 需求: 查询匹配货品名称 '罗技M9?' 的所有信息
SELECT * FROM product WHERE productName LIKE '罗技M9%';

-- 需求: 查询匹配货品名称 '罗技M9??' 的所有信息
SELECT * FROM product WHERE productName LIKE '罗技M9__';

 
 
-- 
 
-- 创建表
CREATE TABLE t_user(
id BIGINT PRIMARY KEY AUTO_INCREMENT,
NAME VARCHAR(20),
age INT(10)
);

-- 删除表
DROP TABLE t_user;

-- 查看表结构
DESC t_user;

-- 查看创建表的语句
SHOW CREATE TABLE t_user;

-- 插入记录
INSERT INTO t_user(id,NAME,age) VALUES(NULL,'decade',12);
INSERT INTO t_user VALUES(NULL,'kiva',18);

-- 删除记录
-- 1. 不带条件
DELETE FROM t_user;
-- 2. 带条件
DELETE FROM t_user WHERE id=1;

-- 修改记录
-- 1. 不带条件 : 修改整张表的数据
UPDATE t_user SET NAME='decade';
-- 2. 带条件 : 修改指定的记录
UPDATE t_user SET NAME='后裔' WHERE id=1;

 -- 1. 查询所有商品信息
SELECT * FROM product;

-- 2. 查询所有商品的id,productName,salePrice
SELECT id,productName,salePrice FROM product;

-- 3. 查询商品的分类编号(消除结果中重复的数据)
SELECT DISTINCT id FROM product;

-- 4. 查询所有货品的id,名称和批发价(批发价=卖价*折扣)
SELECT id,productName,costPrice*cutoff FROM product;

-- 5. 查询所有货品的id,名称和各进50个的成本价(成本=costprice)
SELECT id,productName,costPrice*50 FROM product;

-- 6. 查询所有货品的id,名称和各进50个并且每个运费1元的成本
SELECT id,productName,(costPrice+1)*50 FROM product;

-- 7. 查询 xx的售价是xx
SELECT CONCAT(productName,'的售价是￥',costPrice) FROM product;


-- 2> 比较运算符

-- 需求: 查询货品零售价为119的所有货品信息.
SELECT * FROM product WHERE salePrice=119;

-- 需求: 查询货品名为罗技G9X的所有货品信息.  BINARY区分大小写
SELECT * FROM product WHERE BINARY productName='罗技G9X';

-- 需求: 查询货品名 不为 罗技G9X的所有货品信息.
SELECT * FROM product WHERE productName!='罗技G9X'

-- 需求: 查询分类编号不等于2的货品信息
SELECT * FROM product WHERE dir_id!=2

-- 需求: 查询货品名称,零售价小于等于200的货品
SELECT productName,salePrice FROM product WHERE salePrice<=200;

-- 需求: 查询id，货品名称，批发价大于350的货品
SELECT id,productName,costPrice FROM product WHERE costPrice>350;


-- 3> 逻辑运算符

-- 需求: 选择id，货品名称，零售价在300-400之间的货品
SELECT id,productName,salePrice FROM product WHERE salePrice>300 AND salePrice<400

-- 需求: 选择id，货品名称，分类编号为2或4的所有货品
SELECT id,productName,dir_id FROM product WHERE dir_id=2 OR dir_id=4

-- 需求: 选择id，货品名称，分类编号不为2的所有商品
SELECT id,productName,dir_id FROM product WHERE NOT dir_id=2;

-- 需求: 选择id，货品名称，分类编号的货品零售价大于等于250或者成本大于等于200
SELECT id,productName,dir_id FROM product WHERE salePrice>=250 OR costPrice>=200;


-- 4> 范围查询
-- 需求: 选择id，货品名称，零售价在300-400之间的货品
SELECT id,productName,salePrice FROM product WHERE salePrice BETWEEN 300 AND 400;

-- 需求: 选择id，货品名称，零售价不在300-400之间的货品
SELECT id,productName,salePrice FROM product WHERE salePrice NOT BETWEEN 300 AND 400;

-- 5> 集合查询
-- 需求:选择id，货品名称，分类编号为2或4的所有货品
SELECT id,productName,dir_id FROM product WHERE dir_id IN (2,4);

-- 需求:选择id，货品名称，分类编号不为2或4的所有货品
SELECT id,productName,dir_id FROM product WHERE dir_id NOT IN (2,4);

-- 6> 空值查询
-- 需求:查询商品分类编号为NULL的所有商品信息
SELECT * FROM product WHERE dir_id IS NULL 

-- 需求:查询商品分类编号不为NULL的所有商品信息
SELECT * FROM product WHERE dir_id IS NOT NULL;

-- 设置某一列的数据为null,    列名=null
UPDATE product SET dir_id=NULL WHERE id=20;


-- 7> 模糊查询
-- 需求: 查询货品名称带有 'M' 的所有信息
SELECT * FROM product WHERE productName LIKE '%M%';

-- 需求: 查询匹配货品名称 '罗技M9?' 的所有信息
SELECT * FROM product WHERE productName LIKE '罗技M9%';

-- 需求: 查询匹配货品名称 '罗技M9??' 的所有信息
SELECT * FROM product WHERE productName LIKE '罗技M9__';

     