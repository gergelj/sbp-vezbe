/*
Napisati PL/SQL blok koji će:
a) interaktivno prihvatiti vrednosti za Prz, Ime, Sef, Plt i God, (za MBR koristiti sekvencer)
b) dodati novu torku u tabelu Radnik, s prethodno preuzetim podacima i
c) angažovati novododatog radnika na projektu sa Spr = 10 i 5 sati rada.
*/

-- Napraviti sekvencer ako ne postoji
create sequence radnik_seq
minvalue 250 -- trenutna najveca vrednost mbr-a u bazi
increment by 10;

begin
    insert into radnik (mbr, ime, prz, plt, god) values
    (RADNIK_SEQ.nextval, '&ime', '&prz', &plt, TO_DATE('&date', 'DD-MM-YYYY'));
    
    insert into radproj(spr, mbr, brc)
    values (10, radnik_seq.currval, 5);

    -- commit;
end;