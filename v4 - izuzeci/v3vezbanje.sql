/*
Kreirati anonimni blok koji za uneseni naziv tabele i njene kolone proverava da li oni postoje u bazi podataka.
*/

declare
    var_cnt INTEGER := 0;
    var_tab VARCHAR(30) := '&table';
    var_col VARCHAR(30) := '&column';
begin
    select count(*)
    into var_cnt
    from user_tab_cols
    where UPPER(table_name) = UPPER(var_tab);

    if var_cnt > 0 then
        select count(*)
        into var_cnt
        from user_tab_cols
        where UPPER(table_name) = UPPER(var_tab) and UPPER(column_name) = UPPER(var_col);
        
        if var_cnt > 0 then
            dbms_output.put_line('Kolona "' || var_col || '" postoji u tabeli "' || var_tab || '".');
        else
            dbms_output.put_line('Kolona "' || var_col || '" ne postoji u tabeli "' || var_tab || '".');
        end if;
    else
        dbms_output.put_line('Tabela "' || var_tab || '" ne postoji.');
    end if;
end;