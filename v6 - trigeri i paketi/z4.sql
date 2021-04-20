/*
Formirati triger koji će, nad tabelom Radnik, obezbediti da se prilikom unosa nove torke ili izmene, imena i prezimena radnika uvek zadaju velikim slovima.
*/

create or replace trigger TR_Radnik_capital
before insert or update of ime, prz
on radnik
for each row
begin
    :new.ime := UPPER(:new.ime);
    :new.prz := UPPER(:new.prz);
end;

insert into radnik(mbr, ime, prz, god) values (radnik_seq.nextval, 'ime sa malim slovima', 'prezime sa malim', SYSDATE);

update radnik set ime = 'djura' where mbr = 100;