/*
Formirati triger koji će, nad tabelom Radnik, zabraniti bilo koji pokušaj modifikacije vrednosti primarnog ključa (matičnog broja radnika).
*/

CREATE OR REPLACE TRIGGER TR_Radnik_Mbr_INS
BEFORE UPDATE OF Mbr
ON Radnik
FOR EACH ROW WHEN (OLD.Mbr != NEW.Mbr)
BEGIN
    Raise_application_error(-20326, 'Change of Radnik PRIMARY KEY is not allowed');
END TR_Radnik_Mbr_INS;

UPDATE Radnik set mbr = 4000 where mbr = 470;