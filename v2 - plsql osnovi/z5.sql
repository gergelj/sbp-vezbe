/*
Preko tastature uneti podatke o radniku i upisati ga u bazu podataka. Za matični broj uzeti narednu vrednost iz sekvencera.

Ukoliko je uspešno uneta nova torka, na konzoli ispisati poruku o uspešnom unosu torke. U protivnom, ispisati poruku o neuspešnom unosu.
*/

-- Napraviti sekvencer ako ne postoji
create sequence radnik_seq
minvalue 250 -- trenutna najveca vrednost mbr-a u bazi
increment by 10;

begin
    insert into radnik (mbr, ime, prz, sef, pre,  plt, god) values
    (RADNIK_SEQ.nextval, '&ime', '&prz', &sef, &pre, &plt, TO_DATE('&date', 'DD-MM-YYYY'));
    
    if sql%found then
        dbms_output.put_line('Uspesna uneta torka');
    else
        dbms_output.put_line('Neuspesna uneta torka');
    end if;
end;