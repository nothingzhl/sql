create user liuzhida identified by 'liuzhidahs';

select User,Host,authentication_string from mysql.user where user = 'liuzhida';


desc mysql.user;

grant all privileges on leetcode.* to liuzhida@'%' ;
flush privileges ;

revoke all privileges  on leetcode.* from liuzhida@'%';

grant select on leetcode.* to liuzhida@'%' ;
flush privileges ;

select * from  mysql.db where User = 'liuzhida';

show grants for 'liuzhida';


alter user liuzhida@'%' identified by 'liuzhidasb';
