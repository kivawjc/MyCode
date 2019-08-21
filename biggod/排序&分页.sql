-- 需求：选择id，货品名称，分类编号,零售价先按分类编号排序,编号相同的再按零售价排序
SELECT id,productName,dir_id,salePrice FROM product ORDER BY dir_id,salePrice ASC

-- 需求：选择id，货品名称，分类编号,零售价大于200，先按分类编号排序,编号相同的再按零售价降序排序
SELECT id,productName,dir_id,salePrice FROM product WHERE salePrice>200 ORDER BY dir_id,salePrice DESC

-- 需求: 查询M系列并按照批发价排序(加上别名)
SELECT id,productName,dir_id,salePrice*cutoff sc FROM product
WHERE productName LIKE '%M%'
ORDER BY sc 

-- 需求: 查询分类为2并按照批发价排序(加上别名)
SELECT id,productName,dir_id,salePrice*cutoff sc FROM product
WHERE dir_id=2
ORDER BY sc ASC

-- 需求:每页显示6条记录,查询第3页   (3-1)*6,6
SELECT * FROM product LIMIT 12,6

-- 需求:查询所有商品平均零售价
SELECT AVG(salePrice) FROM product

-- 需求:查询商品总记录数(注意在Java7前必须使用long接收)
SELECT COUNT(*) FROM product

-- 需求:查询分类为2的商品总数
SELECT COUNT(*) FROM product WHERE dir_id=2

-- 需求:查询商品的最小零售价，最高零售价，以及所有商品零售价总和
SELECT MIN(salePrice),MAX(salePrice),SUM(salePrice) FROM product


