/*
Napisati PL/SQL blok koji će za zadati naziv projekta, za svakog radnika koji radi na tom projektu i ima broj časova rada veći od jedan povećati premiju za 10 posto. Ako radnik uopšte nema premiju dati mu premiju od 1000.
*/

declare
    v_nap projekat.nap%type := '&nap';
    v_brc radproj.brc%type := 1;
begin
    update radnik
    set pre = nvl(pre*1.1, 1000)
    where mbr in
        (select rp.mbr
        from projekat p, radproj rp
        where p.spr = rp.spr and p.nap like v_nap and rp.brc > v_brc);
        
    if sql%found then
        DBMS_OUTPUT.PUT_LINE('Updated: ' || sql%rowcount);
    end if;
end;