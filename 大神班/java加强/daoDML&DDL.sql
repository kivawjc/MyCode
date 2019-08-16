

-- 创建表
CREATE TABLE student(
id BIGINT(20) PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(20),
age INT(20)
)

-- 插入
INSERT INTO student(`name`,age) VALUES('decade',18);

-- 删除
DELETE FROM student WHERE id=8;

-- 修改
UPDATE student SET age=20 WHERE id=4;

-- 查询
SELECT * FROM student;



-- 创建表
CREATE TABLE t_product(
id BIGINT(20) PRIMARY KEY AUTO_INCREMENT,
productName VARCHAR(20),
salePrice DECIMAL(8,2),
cutoff DECIMAL(2,2)
)

-- 插入
INSERT INTO t_product(productName,salePrice,cutoff) VALUES('iphonex',5000.0,0.8);

-- 删除
DELETE FROM t_product WHERE id=2;

-- 修改
UPDATE t_product SET salePrice=3000 WHERE id=1;

-- 查询
SELECT * FROM t_product;