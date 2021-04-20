/*
Napisati funkciju koja će, u okviru jedne transakcije, putem kursora, selektovati sve radnike, uređene (sortirane) po zadatom kriterijumu. Kriterijum uređivanja (lista u ORDER BY klauzuli) sastoji se uvek od 3 elementa, čije vrednosti treba preuzeti putem parametara funkcije. Obezbediti programsko (dinamičko) formiranje SELECT naredbe kursorskog područja. Selektovane torke treba preneti u tabelarnu promenljivu (kolekciju). Tabelarna kolekcija selektovanih radnika treba da predstavlja izlazni podatak funkcije.

Neki primeri mogućih SELECT naredbi kursora:
SELECT * FROM RADNIK ORDER BY 3, 2, 1
SELECT * FROM RADNIK ORDER BY Prz, Ime, Mbr
SELECT * FROM RADNIK ORDER BY Mbr, Prz, Ime

Proveriti ispravnost rada funkcije pozivima na konkretnim primerima.
*/

declare
    type Tab_Radnik is table of Radnik%rowtype index by BINARY_INTEGER;
    radnici Tab_Radnik;
    i BINARY_INTEGER;

    function F_radnici_sortirani(param1 in varchar2, param2 in varchar2, param3 in varchar2)
    return Tab_Radnik
    is
        TYPE cur_typ IS REF CURSOR;
        c cur_typ;
        query_str VARCHAR2(200);
        radnici Tab_Radnik;
        i BINARY_INTEGER;
        v_radnik Radnik%rowtype;
    begin
        i := 0;
        query_str := 'SELECT * FROM radnik ORDER BY ' || param1 ||', '|| param2 || ', ' || param3;
        OPEN c FOR query_str;
        LOOP FETCH c INTO v_radnik;
            EXIT WHEN c%NOTFOUND;
            radnici(i) := v_radnik;
            i := i +1;
        END LOOP;
        CLOSE c;
        return radnici;
    end F_radnici_sortirani;

begin
    radnici := F_radnici_sortirani('&param1', '&param2', '&param3');
    i := radnici.first;

    while i is not null loop
        dbms_output.put_line(radnici(i).mbr || ' ' || radnici(i).ime || ' ' || radnici(i).prz);
        i := radnici.next(i);
    end loop;
end;
