/*
Napisati PL/SQL blok koji će preuzeti sve torke iz tabele Projekat i prebaciti ih u PL/SQL tabelarnu kolekciju. Zatim će, redom, odštampati sve elemente tako dobijene tabelarne kolekcije.
*/

declare
    TYPE T_Tab is table of projekat%rowtype index by BINARY_INTEGER;
    v_tab T_Tab;
    i BINARY_INTEGER;
begin
    i := 0;
    for proj in (select * from projekat) loop
        v_tab(i) := proj;
        i := i + 1;
    end loop;
    
    i := v_tab.first;
    
    while i <= v_tab.last loop
        DBMS_OUTPUT.PUT(i || '. ' || v_tab(i).nap);
        i := v_tab.next(i);
    end loop;
end;