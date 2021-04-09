-- Kreirati tabelu Spisak_zarada, korišćenjem SQL komande:

CREATE TABLE Spisak_zarada (
    Mbr NUMBER(3),
    Plt NUMBER(10, 2),
    Evri VARCHAR2(10),
    CONSTRAINT Sz_PK PRIMARY KEY (Mbr)
)

/*
Napisati PL/SQL blok koji će:
za svaku torku iz tabele Radnik, za koju je matični broj u intervalu od 10 do 100, izuzimajući radnika s matičnim brojem 90, preneti u tabelu Spisak_zarada matični broj, iznos plate, i inicijalizovati polje Evri sa vrednošću plate u evrima. Ukoliko radnik već postoji u tabeli izvršiti izmenu vrednosti obeležja Plt i Evri. Kurs evra treba da zadaje korisnik iz okruženja.
*/

ACCEPT E PROMPT 'Kurs evra je: '

DECLARE
    v_Plt Spisak_zarada.Plt%TYPE;
    broj NUMBER :=0;
BEGIN
    FOR i IN 1..10 LOOP
        IF i != 9 THEN
            SELECT Plt INTO v_Plt FROM Radnik
            WHERE Mbr = 10*i;
        
            SELECT COUNT(*) INTO broj FROM Spisak_zarada
            WHERE Mbr = 10*i;
        
            IF broj = 0 THEN
                INSERT INTO Spisak_zarada (Mbr, Plt, Evri)
                VALUES (10*i, v_Plt, v_Plt/&E );
            ELSE
                UPDATE Spisak_zarada
                SET Plt = v_Plt,
                Evri = v_Plt/&E
                WHERE Mbr = 10*i;
            END IF;
        END IF;
    END LOOP;
END;