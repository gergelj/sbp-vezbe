/*
Prebrojati projekte. Rezultat smestiti u definisanu varijablu i prikazati ga u konzoli.
*/

DECLARE
    v_Count NUMBER(3);
BEGIN
    SELECT COUNT(*)
    INTO v_Count
    FROM Projekat;
    
    DBMS_OUTPUT.PUT_LINE(v_Count);
END;