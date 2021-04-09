/*
Ispisati posebno parne, posebno neparne i posebno proste brojeve od 1 do broja unetog sa tastature.
*/

declare
    var_n NUMBER := &n;

begin
    DBMS_OUTPUT.PUT_LINE('Parni brojevi:');
    for i in 1..var_n loop
        if mod(i, 2) = 0 then
            dbms_output.put_line(i);
        end if;
    end loop;
    
    DBMS_OUTPUT.PUT_LINE('Neparni brojevi:');
    for i in 1..var_n loop
        if mod(i, 2) = 1 then
            dbms_output.put_line(i);
        end if;
    end loop;
    
    dbms_output.put_line('Prosti brojevi:');
    if var_n = 2 then
        dbms_output.put_line(2);
    elsif var_n = 3 then
        dbms_output.put_line(2);
        dbms_output.put_line(3);
    elsif var_n > 3 then
        dbms_output.put_line(2);
        dbms_output.put_line(3);
        for i in 3..var_n loop
            if mod(i-1, 6) = 0 or mod(i+1, 6) = 0 then
                dbms_output.put_line(i);
            end if;
        end loop;
    end if;
end;