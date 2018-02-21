create table user (
	id int not null auto_increment,
	name varchar(10) not null,
	phone varchar(20) not null,
	password varchar(20) not null,
	primary key (id)
);

create table blogs (
	id int not null auto_increment,
	title varchar(100) not null,
	text varchar(10000) not null,
	user_id varchar(20) not null,
	time bigInt(12) not null,
	primary key (id)
);

ALTER TABLE blogs MODIFY COLUMN time bigint(14);

insert into blogs(title, text, user_id, time) values('博客测试数据', '博客测试数据，博客测试数据，博客测 试数据，博客测试数据，博客测试数据', 1, '1518746820380');