/*
Sve radnike čiji je matični broj između 1 i 99 označiti za otpuštanje dodavanjem slova X na kraj njihovog prezimena. Ažuriranje obaviti pomoću kursorske UPDATE naredbe. Takođe Izračunati ukupnu svotu novca koja će biti na raspolaganju kompaniji na mesečnom nivou kao posledica njihovog otpuštanja.

Ukoliko ne postoje radnici u tom opsegu matičnih brojeva, poništiti transakciju.

Testirati program i sa unosom opsega matičnih brojeva sa tastature.
*/

declare
    var_sum radnik.plt%type := 0;
    var_count NUMBER := 0;

    cursor radnici(min_mbr radnik.mbr%type, max_mbr radnik.mbr%type) is select * from radnik where mbr between min_mbr and max_mbr
    for update of prz;
    
begin
    for rad in radnici(&min_mbr, &max_mbr) loop
        update radnik
        set prz = prz || ' X'
        where current of radnici;
        
        var_sum := var_sum + rad.plt;
        var_count := var_count + 1;
    end loop;
    
    if var_count = 0 then
        DBMS_OUTPUT.put_line('Ne postoji radnik u ovom opsegu');
        rollback;
    else
        DBMS_OUTPUT.put_line('Usteda = ' || var_sum);
        -- commit;
    end if;
end;