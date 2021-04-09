/*
Sa tastature uneti broj projekta. Za uneseni broj preuzeti njegove podatke u posebne promenjive i prikazati ih u konzoli.
*/

DECLARE
    V_Spr Projekat.Spr%TYPE := 10;
    V_Nap Projekat.Nap%TYPE;
    V_Nar Projekat.Nar%TYPE;
BEGIN
    SELECT Spr, Nap, Nar
    INTO V_Spr, V_Nap, V_Nar
    FROM Projekat
    WHERE Spr = &V_Spr;
    
    DBMS_OUTPUT.PUT_LINE(v_Spr);
    DBMS_OUTPUT.PUT_LINE(v_Nap);
    DBMS_OUTPUT.PUT_LINE(v_Nar);
END;