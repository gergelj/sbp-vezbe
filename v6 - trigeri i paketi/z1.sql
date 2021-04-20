/*
Napisati triger koji za svaku operaciju ažuriranja tabele Radnik, upisuje odgovarajuće podatke u arhivsku (journal) tabelu Radnik_JN. Za operaciju INSERT, isti podaci se prenose i u tabelu Radnik_JN. Za operaciju UPDATE ili DELETE, stare vrednosti torke se prenose u tabelu Radnik_JN.
*/

CREATE TABLE Radnik_JN(
    Dat     DATE NOT NULL,
    Ope    varchar(3) NOT NULL,
    Mbr    integer NOT NULL,
    Ime    varchar(20),
    Prz     varchar(25),
    Plt decimal(10, 2),
    CONSTRAINT radnik_JN_PK PRIMARY KEY (Dat, Ope, Mbr)
);


CREATE OR REPLACE TRIGGER TR_Radnik_JN
BEFORE INSERT OR UPDATE OR DELETE
ON Radnik
FOR EACH ROW
BEGIN
    IF INSERTING THEN
        INSERT INTO radnik_jn(Dat, Ope, Mbr, Ime, Prz, Plt) VALUES (SYSDATE, 'INS', :NEW.MBR, :NEW.IME, :NEW.PRZ, :NEW.PLT);
    ELSIF UPDATING THEN
        INSERT INTO radnik_jn(Dat, Ope, Mbr, Ime, Prz, Plt) VALUES (SYSDATE, 'UPD', :OLD.MBR, :OLD.IME, :OLD.PRZ, :OLD.PLT);
    ELSE
        INSERT INTO radnik_jn(Dat, Ope, Mbr, Ime, Prz, Plt) VALUES (SYSDATE, 'DEL', :OLD.MBR, :OLD.IME, :OLD.PRZ, :OLD.PLT);
    END IF;
END;

INSERT INTO RADNIK VALUES(RADNIK_SEQ.nextval, 'Maja', 'Majic', null, 4567, null, TO_DATE('02-02-1990', 'DD-MM-YYYY'));

UPDATE RADNIK SET IME = 'Majo' WHERE mbr = 290;

DELETE FROM Radnik where mbr = 460;