/*
Formirati triger koji će, nad tabelom Radnik, obezbediti da se prilikom unosa nove torke, uvek zada vrednost matičnog broja kao prva sledeća vrednost iz kreiranog generatora sekvence, bez obzira na to šta je korisnik zadao za vrednost Mbr u klauzuli VALUES.
*/

-- Napraviti sekvencer ako ne postoji
/*
create sequence radnik_seq
minvalue 250 -- trenutna najveca vrednost mbr-a u bazi
increment by 10;
*/

CREATE OR REPLACE TRIGGER TR_Radnik_INS
BEFORE INSERT
ON Radnik
FOR EACH ROW
BEGIN
    :NEW.MBR := RADNIK_SEQ.nextval;
END TR_Radnik_INS;

INSERT INTO Radnik(mbr, ime, prz, plt, god) VALUES (-1, 'Maja', 'Majic', 8000, SYSDATE);