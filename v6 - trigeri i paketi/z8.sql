/*
Napisati proceduru za unos novih podataka u tabelu Projekat. Procedura kao ulazne vrednosti treba da prima podatke o projektu (SPR, NAZP, NAR), i kolekciju radnika koja sadrži par (MBR, BRC). Procedura ima dve izlazne vrednosti: uspešnost unosa torke u tabelu Projekat i broj unetih torki u tabelu Radproj. Procedura treba da obezbedi:
- Proveru da li projekat sa datom šifrom može biti unet. Ukoliko već postoji projekat sa datom šifrom izazvati izuzetak sa odgovarajućom porukom o grešci.
- Proveru da li radnik sa MBR u prosleđenoj kolekciji postoji. Ukoliko ne postoji radnik sa prosleđenik MBR izazvati izuzetak sa odgovarajućom porukom o grešci.
- Obezbediti da se u bazu podataka ili unose sve prethodno navedene torke ili se ne unosi ni jedna. Na osnovu uspešnosti unosa torki dodeliti vrednosti izlaznim parametrima.
*/

create or replace type T_Projekat as object(spr number, nazp varchar2(30), nar varchar2(30), ruk number);

create or replace type T_Radnik_Brc as object(mbr number, brc number);
create or replace type Tab_Radnik as table of T_Radnik_Brc;

create or replace procedure P_Unos_projekta(p_projekat in T_Projekat, p_radnici in Tab_Radnik, uspeh out boolean, broj_torki out number) is
    v_proj_cnt number := 0;
    v_radnik_cnt number;
    i binary_integer;
begin
    broj_torki := 0;
    uspeh := false;
    
    select count(*)
    into v_proj_cnt
    from projekat
    where spr = p_projekat.spr;
    
    if v_proj_cnt > 0 then
        Raise_application_error(-20000, 'Projekat sa sifrom ' || p_projekat.spr || ' vec postoji.');
    end if;
    
    select count(*)
    into v_proj_cnt
    from radnik
    where mbr = p_projekat.ruk;
    
    if v_proj_cnt = 0 then
        Raise_application_error(-20001, 'Rukovodilac sa sifrom ' || p_projekat.ruk || ' ne postoji.');
    end if;
    
    insert into projekat values (p_projekat.spr, p_projekat.ruk, p_projekat.nazp, p_projekat.nar);
    uspeh := sql%found;
    
    i := p_radnici.first;
    
    while i is not null loop
        select count(*)
        into v_radnik_cnt
        from radnik
        where mbr = p_radnici(i).mbr;
        if v_radnik_cnt = 0 then
            Raise_application_error(-20002, 'Radnik sa sifrom ' || p_radnici(i).mbr || ' ne postoji.');
        end if;
        
        insert into radproj values (p_projekat.spr, p_radnici(i).mbr, p_radnici(i).brc);
        broj_torki := broj_torki + 1;
        i := p_radnici.next(i);
    end loop;
end;

-- Testiranje

declare
    v_projekat T_Projekat;
    v_radnici Tab_Radnik;
    v_uspeh boolean;
    v_broj_torki number;
begin
    v_projekat := T_Projekat(90, 'Naziv projekta', 'Narucilac projekta', 10);
    v_radnici := Tab_Radnik(
        T_Radnik_brc(10, 5),
        T_Radnik_brc(30, 12),
        T_Radnik_brc(60, 4),
        T_Radnik_brc(80, 1)
    );
    
    P_Unos_projekta(v_projekat, v_radnici, v_uspeh, v_broj_torki);
    
    if v_uspeh then
        dbms_output.put_line('Uspesno unet projekat. Broj torki = ' || v_broj_torki);
    else 
        dbms_output.put_line('Neuspesno unet projekat. Broj torki = ' || v_broj_torki);
    end if;
end;