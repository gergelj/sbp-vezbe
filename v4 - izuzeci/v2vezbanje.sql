/*
Kreirati anonimni blok koji za uneseni niz karaktera sa tastature kreira njegov akronim izdvajanjem prvih velikih slova iz svake reči.

Na primer:
- Structured Query Language -> SQL
- GNU is Not Unix -> GNU
*/

declare
    var_str VARCHAR2(100) := '&str';
    var_char CHAR;
    alphabet VARCHAR2(30) := 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    is_new_word BOOLEAN := FALSE;
    rez VARCHAR2(30) := '';
begin
    if var_str = '' then
        DBMS_OUTPUT.PUT_LINE('Niste uneli string');
    else
        for i in 1..length(var_str) loop
            var_char := SUBSTR(var_str, i, 1);
            if i = 1 or is_new_word then
                if INSTR(alphabet, var_char) > 0 then
                    rez := rez || var_char;
                end if;
                is_new_word := FALSE;
            end if;
            
            if var_char = ' ' then
                is_new_word := TRUE;
            end if;
        end loop;
        DBMS_OUTPUT.put_line('Akronim: ' || rez);
    end if;
end;