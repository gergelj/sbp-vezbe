/*
Napisati funkciju koja će, u okviru jedne transakcije, putem kursora, preuzimati, redom, sve torke iz tabele Radnik, uređene u opadajućem redosledu matičnog broja, i prebacivati ih u PL/SQL tabelarnu kolekciju. Uz svaku preuzetu torku iz tabele Radnik, treba u okviru elementa te kolekcije, inicijalizovati novu kolekciju koja će sadržati skup svih naziva projekata na kojima ti radnici rade. Takođe, treba za svakog radnika prikazati i nazive projekata kojima rukovodi. Nazive projekata na kojima radnik radi i kojima rukovodi, treba selektovati putem posebnih kursora.
Tabelarna kolekcija selektovanih radnika treba da predstavlja izlazni podatak funkcije.
Proveriti ispravnost rada funkcije pozivima na konkretnim primerima.
*/


declare
    type T_Naz_Proj is table of projekat.nap%type index by BINARY_INTEGER;
    
    type R_Radnik is RECORD(
        v_Rad radnik%rowtype,
        v_Nap_Rad T_Naz_Proj,
        v_Nap_Ruk T_Naz_Proj
    );
    
    type T_Radnik is table of R_Radnik index by BINARY_INTEGER;
    
    i binary_integer;
    j binary_integer;
    radnici T_Radnik;

    function F_nazivi_projekta_ruk(rad_mbr in Radnik.mbr%type) return T_Naz_Proj is
        v_Naz_Proj T_Naz_Proj;
        cursor C_nazivi_proj_ruk(r_mbr radnik.mbr%type) is select nap from projekat where ruk = r_mbr;
        i BINARY_INTEGER;
    begin
        i := 0;
        for naz_proj in C_nazivi_proj_ruk(rad_mbr) loop
            v_Naz_Proj(i) := naz_proj.nap;
            i := i + 1;
        end loop;
        
        return v_Naz_Proj;
    end F_nazivi_projekta_ruk;


    function F_nazivi_projekta_rad(rad_mbr in Radnik.mbr%type) return T_Naz_Proj is
        v_Naz_Proj T_Naz_Proj;
        cursor C_nazivi_proj_rad(r_mbr radnik.mbr%type) is select p.nap from projekat p, radproj rp where p.spr = rp.spr and rp.mbr = r_mbr;
        i BINARY_INTEGER;
    begin
        i := 0;
        for naz_proj in C_nazivi_proj_rad(rad_mbr) loop
            v_Naz_Proj(i) := naz_proj.nap;
            i := i + 1;
        end loop;
        return v_Naz_Proj;
    end F_nazivi_projekta_rad;
    

    function F_ucitaj_TAB_radnik return T_Radnik is
        radnici T_Radnik;
        i BINARY_INTEGER := 0;
    begin
        for rad in (select * from radnik order by mbr desc) loop
            radnici(i).v_Rad := rad;
            radnici(i).v_Nap_Rad := F_nazivi_projekta_rad(rad.mbr);
            radnici(i).v_Nap_Ruk := F_nazivi_projekta_ruk(rad.mbr);
            i := i + 1;
        end loop;
        return radnici;
    end F_ucitaj_TAB_radnik;
begin
    radnici := F_ucitaj_TAB_radnik();
    i := radnici.first;
    
    while i is not null loop
        dbms_output.put_line(radnici(i).v_Rad.mbr || ' ' || radnici(i).v_Rad.ime || ' ' || radnici(i).v_Rad.prz);
        
        j := radnici(i).v_Nap_Rad.first;
        dbms_output.put_line('   - Projekti na kojima radi:');
        while j is not null loop
            dbms_output.put_line('     ' || TO_CHAR(j+1) || '. ' || radnici(i).v_Nap_Rad(j));
            j := radnici(i).v_Nap_Rad.next(j);
        end loop;
        
        j := radnici(i).v_Nap_Ruk.first;
        dbms_output.put_line('   - Projekti kojima rukovodi:');
        while j is not null loop
            dbms_output.put_line('     ' || TO_CHAR(j+1) || '. ' || radnici(i).v_Nap_Ruk(j));
            j := radnici(i).v_Nap_Ruk.next(j);
        end loop;

        i := radnici.next(i);
    end loop;
end;