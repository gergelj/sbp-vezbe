/*
Napisati PL/SQL blok koji će za zadato ime i prezime šefa ispisati njegove radnike.

Radnici kojima je sef ...
Ime zaposlenog je ...
Ime zaposlenog je ...
*/

declare
    CURSOR spisak_sef (r_ime Radnik.ime%type, r_prz radnik.prz%type) is
    select *
    from radnik
    where ime like r_ime and prz like r_prz;

    v_sef Radnik%ROWTYPE;
    
    CURSOR spisak_rad (r_sef radnik.sef%type) is
    select *
    from radnik
    where sef = r_sef;
    
    v_radnik Radnik%ROWTYPE;
begin
    OPEN spisak_sef('&ime', '&prz');
    
    LOOP
        FETCH spisak_sef INTO v_sef;
        EXIT WHEN spisak_sef%NOTFOUND or spisak_sef%ROWCOUNT > 1;
        
        DBMS_OUTPUT.PUT_LINE('Radnici kojima je sef ' || v_sef.ime || ' ' || v_sef.prz);
        
        OPEN spisak_rad(v_sef.mbr);
        LOOP
            FETCH spisak_rad into v_radnik;
            EXIT WHEN spisak_rad%NOTFOUND;
            
            DBMS_OUTPUT.PUT_LINE('Ime zaposlenog je ' || v_radnik.ime || ' ' || v_radnik.prz);
        END LOOP;
        CLOSE spisak_rad;
        DBMS_OUTPUT.PUT_LINE('');
    END LOOP;
    
    
    

end;