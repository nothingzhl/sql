drop table if exists vote_record;
create table `vote_record`
(
    `id`          int(11)     not null auto_increment,
    `user_id`     varchar(20) not null,
    `vote_id`     int(11)     not null,
    `group_id`    int(11)     not null,
    `create_time` datetime    not null,
    primary key (`id`),
    key `index_user_id` (`user_id`)
) engine = innodb
  default charset = utf8mb4;

drop table if exists vote_record_memory;
create table `vote_record_memory`
(
    `id`          int(11)     not null auto_increment,
    `user_id`     varchar(20) not null,
    `vote_id`     int(11)     not null,
    `group_id`    int(11)     not null,
    `create_time` datetime    not null,
    primary key (`id`),
    key `index_user_id` (`user_id`)
) engine = innodb
  default charset = utf8mb4;


drop function if exists rand_string;

delimiter $

create function rand_string(n int)
    returns varchar(255)

begin
    declare chars_str varchar(100) default 'abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyz0123456789';
    declare return_value varchar(255) default '';
    declare i int default 0;
    while (i < n)
        do
            set return_value = concat(return_value, substring(chars_str, floor(1 + rand() * 62), 1));
            set i = i + 1;
        end while;
    return return_value;
end $
delimiter ;

drop procedure if exists add_vote_memory;

delimiter $

create procedure add_vote_memory(in n int)
begin
    declare i int default 1;
    while (i <= n)
        do
            insert into vote_record_memory (user_id, vote_id, group_id, create_time)
            values (rand_string(20), floor(rand() * 1000), floor(rand() * 100), now());
            set i = i + 1;
        end while;
end$

delimiter ;

call add_vote_memory(1000000);

insert into vote_record
select *
from vote_record_memory;

select count(*)
from vote_record;

create view vote_record_view as
select user_id, vote_id
from vote_record;

select *
from vote_record_view;

alter
    definer
        =
        current_user
    sql
        security
        definer
    view
    vote_record_view as
    select user_id, vote_id
    from vote_record with check option ;



