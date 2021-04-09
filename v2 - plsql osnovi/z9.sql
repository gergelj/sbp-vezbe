/*
Napisati PL/SQL blok koji će:
a) izbrisati angažovanje prethodno dodatog radnika na projektu sa šifrom 10 i obavestiti porukom korisnika da li je brisanje uspešno obavljeno,
b) izbrisati prethodno dodatog radnika iz evidencije i obavestiti porukom korisnika da li je brisanje uspešno obavljeno,
c) sačuvati vrednost za Mbr izbrisanog radnika u lokalnoj promenljivoj pod nazivom Del_Mbr
*/

ACCEPT v_Mbr PROMPT 'MBR = '
DECLARE
    Del_Mbr radnik.Mbr%TYPE;
BEGIN
    DELETE FROM radproj
    WHERE Mbr = &&v_Mbr AND Spr = 10;
    
    IF SQL%FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Brisanje rada na projektu uspesno obavljeno.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Brisanje rada na projektu nije uspesno obavljeno.');
    END IF;
    
    DELETE FROM radnik
    WHERE Mbr = &&v_Mbr ;
    
    IF SQL%FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Brisanje radnika uspesno obavljeno.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Brisanje radnika nije uspesno obavljeno.');
    END IF;
    
    Del_Mbr := &&v_Mbr;
END;