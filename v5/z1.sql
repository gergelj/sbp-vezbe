/*
Napisati lokalnu proceduru koja će, u okviru jedne transakcije, putem kursora, preuzimati, redom, sve torke iz tabele Radnik i prebacivati ih, jednu po jednu, u PL/SQL tabelarnu kolekciju. Takva tabelarna kolekcija treba da predstavlja izlazni parametar procedure.
Proveriti ispravnost rada procedure pozivima na konkretnim primerima!
*/

declare
    type T_radnik is table of radnik%rowtype index by BINARY_INTEGER;
    i binary_integer := 0;
    radnici T_radnik;
    procedure P_ucitaj_TAB_radnik(tab_radnik out T_radnik) is
        i BINARY_INTEGER := 0;
    begin
        for rad in (select * from radnik) loop
            tab_radnik(i) := rad;
            i := i + 1;
        end loop;
    end P_ucitaj_TAB_radnik;
begin
    P_ucitaj_TAB_radnik(radnici);
    i := radnici.first;
    
    while i is not null loop
        dbms_output.put_line(radnici(i).mbr || ' ' || radnici(i).prz);
        i := radnici.next(i);
    end loop;
end;