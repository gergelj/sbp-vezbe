/*
Formirati triger koji će, nad tabelom Radnik, obezbediti da se prilikom unosa nove torke, brisanja ili izmene vrednosti obeležja pre triger aktivira samo ukoliko je stara plata veća od 8000. Ukoliko se radi o brisanju zabraniti ga. Ukoliko se radi o unosu, uneti samo one čija je premija veća od deset posto plate a ukoliko se radi o izmeni dozvoliti izmenu samo ako je nova vrednost premije veća pet posto od prethodne vrednosti premije.
*/

create or replace trigger TR_Radnik_pre
before insert or update of pre or delete
on Radnik
for each row when (old.plt > 8000)
declare
    excDelete exception;
    excInsert exception;
    excUpdate exception;
begin
    if deleting then
        raise excDelete;
    elsif inserting then
        if not(:new.pre > :new.plt * 0.1) then
            raise excInsert;
        end if;
    else
        if not(:new.pre > :old.pre * 1.05) then
            raise excUpdate;
        end if;
    end if;
    
exception
    when excDelete then
        Raise_application_error(20000, 'Brisanje nije omoguceno');
    when excInsert then
        Raise_application_error(20001, 'Premija nije veca od deset posto plate');
    when excUpdate then
        Raise_application_error(20002, 'Nova premija nije veca pet posto prethodne premije');
end TR_Radnik_pre;