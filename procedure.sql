delimiter $
create procedure procedure_test(in v_min int, in v_max int, out num int)
    reads sql data
    sql security invoker
begin
    select *
    from stadium
    where people > v_min
      and people < v_max;

    select found_rows() into num;
end $
delimiter ;

call procedure_test(10, 1000, @a);

show procedure status like '%procedure%';

delimiter $

create function function_test(v_min int, v_max int)
    returns int
    reads sql data
    sql security invoker
begin
    declare temp int;
    select count(*)
    into @temp
    from stadium
    where people > v_min
      and people < v_max;
    return @temp;
end $
delimiter ;

select function_test(0, 1000);

delimiter $
create procedure pro_procedure()
begin
    set @x = 1;
    select * from test11;
    set @x = 2;
end $
delimiter ;
call pro_procedure();
select @x;

drop procedure pro_procedure;

delimiter $

create procedure pro_procedure_handler()
begin
    declare continue handler for 1146 set @x2 = 1;
    set @x = 1;
    select * from test11;
    set @x = 2;
end $
delimiter ;
call pro_procedure_handler();
select @x, @x2;

delimiter $

create procedure procedure_cursor()

begin
    declare people_i int;
    declare cur_test cursor for select people from stadium;
    DECLARE EXIT HANDLER FOR NOT FOUND CLOSE cur_test;

    set @x1 = 0;
    set @x2 = 0;

    open cur_test;

    repeat

        fetch cur_test into people_i;
        SET @x1 = @x1 + people_i;
        SET @x2 = @x2 + 1;

    until 0 end repeat;

    close cur_test;

end $

delimiter ;

call procedure_cursor();
select @x1, @x2;

delimiter $

create procedure if_procedure(in v_condition int)

begin
    if v_condition < 10 then
        select 1;
    else
        select 2;
    end if;
end $

delimiter ;
call if_procedure(12);

delimiter $
create procedure case_procedure(in v_condition int)

begin
    case v_condition
        when 10 then
            select 10; else
            select 20;
        end case;
end $

delimiter ;
call case_procedure(10);

delimiter $

create procedure while_procedure(in v_condition int)
begin
    set @x = v_condition;
    while @x1 < 0
        do
            set @x = @x - 1;
        end while;
end $

delimiter ;
call while_procedure(100);
select @x;



