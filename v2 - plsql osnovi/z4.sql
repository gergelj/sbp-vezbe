/*
U konzolu ispisati radnika (mbr, ime, prezime i platu) čiji je matični broj jednak matičnom broju unetom preko prompta.

Takođe prikazati jednog radnika čije ime počinje na slovo uneto sa prompta.
*/

declare
    v_radnik radnik%ROWTYPE;
begin
    select *
    into v_radnik
    from radnik
    where mbr = &v_mbr;
    
    DBMS_OUTPUT.put_line(v_radnik.mbr || ' ' || v_radnik.ime || ' ' || v_radnik.prz || ' ' || v_radnik.plt);
    
    select *
    into v_radnik
    from radnik
    where ime like '&v_slovo%' and rownum <= 1;
    
    DBMS_OUTPUT.put_line(v_radnik.mbr || ' ' || v_radnik.ime || ' ' || v_radnik.prz || ' ' || v_radnik.plt);
end;